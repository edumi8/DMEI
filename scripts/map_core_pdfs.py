#!/usr/bin/env python3
"""
Map Core citation keys to PDF files using BibTeX and Zotero RDF data.

Priority:
1. BibTeX file = {...} field (highest priority)
2. DOI match
3. Exact normalized title match (no fuzzy)

Features:
- YAML alias support (Core key → BibTeX key)
- --check mode to verify PDF paths exist on disk
"""

import re
import xml.etree.ElementTree as ET
import argparse
import sys
from pathlib import Path
from typing import Dict, List, Tuple, Optional

try:
    import yaml
except ImportError:
    print("ERROR: PyYAML not installed. Install with: pip install pyyaml", file=sys.stderr)
    sys.exit(1)

# Paths
FULL_TEXT_PRIORITY = Path("ch2_literature/full_text_priority.md")
BIBTEX_FILE = Path("references/A minha Biblioteca/A minha Biblioteca/A minha Biblioteca.bib")
RDF_FILE = Path("references/A minha Biblioteca/Files/Files.rdf")
ALIAS_FILE = Path("scripts/core_key_aliases.yml")
OUTPUT_FILE = Path("ch2_literature/core_pdfs.md")

# RDF namespaces
NAMESPACES = {
    'rdf': 'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
    'dc': 'http://purl.org/dc/elements/1.1/',
    'dcterms': 'http://purl.org/dc/terms/',
    'bib': 'http://purl.org/net/biblio#',
    'z': 'http://www.zotero.org/namespaces/export#',
    'link': 'http://purl.org/rss/1.0/modules/link/'
}

def load_aliases() -> Dict[str, str]:
    """Load citation key aliases from YAML file"""
    if not ALIAS_FILE.exists():
        return {}
    
    with open(ALIAS_FILE, 'r', encoding='utf-8') as f:
        try:
            data = yaml.safe_load(f)
            return data if isinstance(data, dict) else {}
        except yaml.YAMLError as e:
            print(f"WARNING: Failed to parse {ALIAS_FILE}: {e}", file=sys.stderr)
            return {}

def extract_core_keys() -> List[str]:
    """Extract citation keys marked as Core from full_text_priority.md"""
    core_keys = []
    with open(FULL_TEXT_PRIORITY, 'r', encoding='utf-8') as f:
        for line in f:
            if '| Core |' in line or '| Core ' in line:
                match = re.match(r'\|\s*(\S+)\s*\|', line)
                if match:
                    key = match.group(1).strip()
                    if key and key != 'Citation':
                        core_keys.append(key)
    return core_keys

def parse_bibtex_entry(entry_text: str) -> Dict[str, str]:
    """Parse a single BibTeX entry into a dict"""
    data = {}
    
    # Extract citation key
    key_match = re.search(r'@\w+\{([^,]+),', entry_text)
    if key_match:
        data['key'] = key_match.group(1).strip()
    
    # Extract DOI
    doi_match = re.search(r'doi\s*=\s*\{([^}]+)\}', entry_text, re.IGNORECASE)
    if doi_match:
        doi = doi_match.group(1).strip()
        # Clean DOI - remove URL prefixes
        doi = re.sub(r'https?://(dx\.)?doi\.org/', '', doi)
        data['doi'] = doi.lower()
    
    # Extract title
    title_match = re.search(r'title\s*=\s*\{([^}]+)\}', entry_text, re.IGNORECASE)
    if title_match:
        title = title_match.group(1).strip()
        # Remove LaTeX formatting
        title = re.sub(r'\{\{([^}]+)\}\}', r'\1', title)
        title = re.sub(r'\{([^}]+)\}', r'\1', title)
        data['title'] = title
    
    # Extract file field (highest priority for PDF path)
    file_match = re.search(r'file\s*=\s*\{([^}]+)\}', entry_text, re.IGNORECASE)
    if file_match:
        file_field = file_match.group(1).strip()
        # Extract PDF path (format: "path/to.pdf" or just path/to.pdf)
        pdf_matches = re.findall(r'([^;:]+\.pdf)', file_field, re.IGNORECASE)
        if pdf_matches:
            data['file_pdf'] = pdf_matches[0].strip()
    
    return data

def load_bibtex_data(keys: List[str]) -> Dict[str, Dict[str, str]]:
    """Load BibTeX entries for given citation keys"""
    entries = {}
    with open(BIBTEX_FILE, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Split into entries
    bibtex_entries = re.split(r'\n(?=@)', content)
    
    for entry_text in bibtex_entries:
        if not entry_text.strip():
            continue
        
        data = parse_bibtex_entry(entry_text)
        if 'key' in data and data['key'] in keys:
            entries[data['key']] = data
    
    return entries

def normalize_title(title: str) -> str:
    """Normalize title for comparison"""
    # Remove special chars, lowercase, collapse whitespace
    title = re.sub(r'[^\w\s]', '', title.lower())
    title = re.sub(r'\s+', ' ', title).strip()
    return title

def extract_rdf_items() -> List[Dict[str, str]]:
    """Extract items from RDF with DOI, title, and PDF path"""
    tree = ET.parse(RDF_FILE)
    root = tree.getroot()
    
    items = []
    
    # Find all Document/Article/Book/Thesis elements
    for elem in root.findall('.//{http://purl.org/net/biblio#}Article', NAMESPACES):
        item = extract_rdf_item_data(elem, root)
        if item:
            items.append(item)
    
    for elem in root.findall('.//{http://purl.org/net/biblio#}Document', NAMESPACES):
        item = extract_rdf_item_data(elem, root)
        if item:
            items.append(item)
    
    for elem in root.findall('.//{http://purl.org/net/biblio#}Book', NAMESPACES):
        item = extract_rdf_item_data(elem, root)
        if item:
            items.append(item)
    
    for elem in root.findall('.//{http://purl.org/net/biblio#}Thesis', NAMESPACES):
        item = extract_rdf_item_data(elem, root)
        if item:
            items.append(item)
    
    # Also check rdf:Description
    for elem in root.findall('.//{http://www.w3.org/1999/02/22-rdf-syntax-ns#}Description', NAMESPACES):
        item = extract_rdf_item_data(elem, root)
        if item:
            items.append(item)
    
    return items

def extract_rdf_item_data(elem, root) -> Optional[Dict[str, str]]:
    """Extract data from a single RDF item"""
    item = {}
    
    # Extract title
    title_elem = elem.find('.//dc:title', NAMESPACES)
    if title_elem is not None and title_elem.text:
        item['title'] = title_elem.text.strip()
    
    # Extract DOI from dc:identifier or Journal element
    for id_elem in elem.findall('.//dc:identifier', NAMESPACES):
        if id_elem.text and 'DOI' in id_elem.text.upper():
            doi_text = id_elem.text.strip()
            # Extract DOI number
            doi_match = re.search(r'DOI\s+(10\.\S+)', doi_text, re.IGNORECASE)
            if doi_match:
                item['doi'] = doi_match.group(1).lower()
                break
    
    # Check if there's a dcterms:identifier with DOI
    for id_elem in elem.findall('.//dcterms:identifier', NAMESPACES):
        doi_elem = id_elem.find('.//dcterms:URI/rdf:value', NAMESPACES)
        if doi_elem is not None and doi_elem.text and 'doi.org' in doi_elem.text:
            doi = re.sub(r'https?://(dx\.)?doi\.org/', '', doi_elem.text.strip())
            item['doi'] = doi.lower()
            break
    
    # Find linked attachment (PDF)
    link_elem = elem.find('.//link:link', NAMESPACES)
    if link_elem is not None:
        resource_ref = link_elem.get('{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource')
        if resource_ref:
            # Find attachment by ID
            attachment = root.find(f'.//*[@{{http://www.w3.org/1999/02/22-rdf-syntax-ns#}}about="{resource_ref}"]')
            if attachment is not None:
                resource_elem = attachment.find('.//rdf:resource', NAMESPACES)
                if resource_elem is not None:
                    resource_path = resource_elem.get('{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource')
                    if resource_path and resource_path.endswith('.pdf'):
                        item['pdf'] = resource_path
    
    return item if 'title' in item else None

def match_citation_to_pdf(cite_key: str, bib_data: Dict[str, str], rdf_items: List[Dict[str, str]]) -> Tuple[bool, str]:
    """
    Match citation key to PDF file with priority:
    1. BibTeX file field (highest priority)
    2. DOI match with RDF
    3. Exact title match with RDF
    
    Returns: (success: bool, result: str)
    """
    
    # Check if we have BibTeX data
    if not bib_data:
        return False, "No BibTeX entry found"
    
    # PRIORITY 1: Check BibTeX file field first (highest priority)
    if 'file_pdf' in bib_data:
        pdf_path = bib_data['file_pdf']
        # Path is already relative to "Files/" directory from Zotero
        # Convert to repository-relative path
        if not pdf_path.startswith('references/'):
            pdf_path = f"references/A minha Biblioteca/Files/{pdf_path}"
        return True, pdf_path
    
    # PRIORITY 2: Try DOI match with RDF
    if 'doi' in bib_data:
        cite_doi = bib_data['doi']
        for rdf_item in rdf_items:
            if 'doi' in rdf_item and rdf_item['doi'] == cite_doi:
                if 'pdf' in rdf_item:
                    # RDF paths start with "files/" - convert to repository path
                    pdf_path = rdf_item['pdf'].replace('files/', 'references/A minha Biblioteca/Files/files/')
                    return True, pdf_path
                else:
                    return False, f"DOI match found but no PDF attached (DOI: {cite_doi})"
        return False, f"No RDF entry with matching DOI: {cite_doi}"
    
    # PRIORITY 3: Fallback to exact title match
    if 'title' in bib_data:
        cite_title_norm = normalize_title(bib_data['title'])
        
        for rdf_item in rdf_items:
            if 'title' in rdf_item:
                rdf_title_norm = normalize_title(rdf_item['title'])
                if cite_title_norm == rdf_title_norm:
                    if 'pdf' in rdf_item:
                        # RDF paths start with "files/" - convert to repository path
                        pdf_path = rdf_item['pdf'].replace('files/', 'references/A minha Biblioteca/Files/files/')
                        return True, pdf_path
                    else:
                        return False, f"Title match found but no PDF attached"
        
        return False, "No RDF entry with exact title match"
    
    return False, "No DOI or title in BibTeX entry"

def check_pdf_exists(pdf_path: str, repo_root: Path) -> bool:
    """Check if PDF file exists on disk"""
    # Path is already in correct format from match_citation_to_pdf
    full_path = repo_root / pdf_path
    return full_path.exists()

def main():
    parser = argparse.ArgumentParser(
        description="Map Core citation keys to PDF files",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Priority matching order:
  1. BibTeX file field (highest priority)
  2. DOI match with RDF
  3. Exact normalized title match with RDF

Examples:
  %(prog)s              # Generate mapping
  %(prog)s --check      # Verify PDF files exist on disk
        """
    )
    parser.add_argument(
        '--check',
        action='store_true',
        help='Verify that resolved PDF paths exist on disk'
    )
    args = parser.parse_args()
    
    repo_root = Path(__file__).parent.parent
    
    print("=== Core Papers PDF Mapper ===\n")
    
    # Step 1: Load aliases
    print("Step 1: Loading citation key aliases...")
    aliases = load_aliases()
    print(f"  Loaded {len(aliases)} aliases\n")
    
    # Step 2: Extract Core keys
    print("Step 2: Extracting Core citation keys...")
    core_keys = extract_core_keys()
    print(f"  Found {len(core_keys)} Core papers\n")
    
    # Step 3: Resolve aliases
    print("Step 3: Resolving aliases to BibTeX keys...")
    resolved_keys = []
    key_map = {}  # Original key -> BibTeX key
    for key in core_keys:
        bibtex_key = aliases.get(key, key)
        resolved_keys.append(bibtex_key)
        key_map[key] = bibtex_key
        if bibtex_key != key:
            print(f"  {key} → {bibtex_key}")
    print(f"  Resolved {len(resolved_keys)} keys\n")
    
    # Step 4: Load BibTeX data
    print("Step 4: Loading BibTeX data...")
    bibtex_data = load_bibtex_data(resolved_keys)
    print(f"  Loaded {len(bibtex_data)} BibTeX entries\n")
    
    # Step 5: Load RDF data
    print("Step 5: Parsing Zotero RDF...")
    rdf_items = extract_rdf_items()
    print(f"  Found {len(rdf_items)} RDF items\n")
    
    # Step 6: Match each Core key
    print("Step 6: Matching Core keys to PDFs...\n")
    resolved = []
    unresolved = []
    
    for orig_key in core_keys:
        bibtex_key = key_map[orig_key]
        bib_data = bibtex_data.get(bibtex_key, {})
        success, result = match_citation_to_pdf(bibtex_key, bib_data, rdf_items)
        
        if success:
            resolved.append((orig_key, result))
            print(f"  ✓ {orig_key}")
        else:
            unresolved.append((orig_key, result))
            print(f"  ✗ {orig_key}: {result}")
    
    # Step 7: Verify PDF existence if --check
    missing_pdfs = []
    if args.check:
        print("\nStep 7: Verifying PDF files exist on disk...")
        for key, pdf_path in resolved:
            if not check_pdf_exists(pdf_path, repo_root):
                missing_pdfs.append((key, pdf_path))
                print(f"  ✗ MISSING: {key}")
        if not missing_pdfs:
            print(f"  ✓ All {len(resolved)} PDFs exist on disk")
        else:
            print(f"  ✗ {len(missing_pdfs)} PDFs not found on disk")
        print()
    
    # Step 8: Write output
    step_num = 8 if args.check else 7
    print(f"Step {step_num}: Writing results to {OUTPUT_FILE}...")
    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        f.write("# Core Papers – PDF Mapping\n\n")
        f.write("**Generated:** Auto-mapped using file field, DOI, and exact title matching\n\n")
        
        f.write(f"## Resolved ({len(resolved)})\n\n")
        for key, pdf_path in sorted(resolved):
            # Path is already in correct format from match_citation_to_pdf
            
            # Check if missing
            status = ""
            if args.check and not check_pdf_exists(pdf_path, repo_root):
                status = " ⚠️ **FILE NOT FOUND**"
            
            f.write(f"- `{key}`{status}  \n")
            f.write(f"  {pdf_path}\n\n")
        
        if missing_pdfs:
            f.write(f"### ⚠️ Missing Files ({len(missing_pdfs)})\n\n")
            f.write("The following resolved mappings have missing PDF files on disk:\n\n")
            for key, pdf_path in sorted(missing_pdfs):
                f.write(f"- `{key}` — {pdf_path}\n")
            f.write("\n")
        
        f.write(f"## Unresolved ({len(unresolved)})\n\n")
        for key, reason in sorted(unresolved):
            f.write(f"- `{key}` — {reason}\n\n")
    
    print(f"\n=== Summary ===")
    print(f"  Resolved:   {len(resolved)}/{len(core_keys)}")
    print(f"  Unresolved: {len(unresolved)}/{len(core_keys)}")
    if args.check and missing_pdfs:
        print(f"  Missing:    {len(missing_pdfs)}/{len(resolved)} (PDF files not found on disk)")
    print(f"  Output:     {OUTPUT_FILE}")

if __name__ == "__main__":
    main()
