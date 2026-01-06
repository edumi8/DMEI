# Core Papers PDF Mapper

Automatically maps Core citation keys from PRISMA literature review to local PDF files.

## Features

- **YAML Alias Support**: Maps Core citation keys to BibTeX keys via `core_key_aliases.yml`
- **Priority Matching**:
  1. BibTeX `file` field (highest priority - direct path)
  2. DOI match with Zotero RDF
  3. Exact normalized title match with RDF
- **Path Verification**: `--check` mode verifies PDF files exist on disk
- **Strict Matching**: No fuzzy matching - only exact DOI or title matches

## Usage

```bash
# Generate mapping
python scripts/map_core_pdfs.py

# Generate mapping and verify PDFs exist
python scripts/map_core_pdfs.py --check
```

## Files

- **Input**:
  - `ch2_literature/full_text_priority.md` - PRISMA classification with Core papers
  - `references/A minha Biblioteca/A minha Biblioteca/A minha Biblioteca.bib` - BibTeX bibliography
  - `references/A minha Biblioteca/Files/Files.rdf` - Zotero attachment metadata
  - `scripts/core_key_aliases.yml` - Citation key aliases (Core → BibTeX)

- **Output**:
  - `ch2_literature/core_pdfs.md` - Resolved and unresolved paper mappings

## Alias Configuration

Edit `scripts/core_key_aliases.yml` to map Core citation keys to BibTeX keys:

```yaml
# Maps shortened keys to full BibTeX keys
karkanPerformanceOverheadOpenTelemetry: karkanPerformanceOverheadOpenTelemetry2024
InvestigatingPerformanceOverhead: nouInvestigatingPerformanceOverhead
```

## Matching Strategy

1. **BibTeX file field**: If BibTeX entry has `file = {path/to.pdf}`, use that path directly
2. **DOI matching**: Compare normalized DOIs between BibTeX and RDF entries
3. **Title matching**: Compare normalized titles (case-insensitive, punctuation removed)

## Requirements

- Python 3.7+
- PyYAML: `pip install pyyaml`

## Current Status

✅ **25/25 Core papers resolved** (100%)
✅ **All PDF files verified on disk**
