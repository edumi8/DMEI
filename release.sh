#!/bin/bash
#########################################################################
# TMDEI Thesis Release Script
# 
# This script automates the process of creating a release package for
# thesis submission to teachers/supervisors.
#
# Usage: ./release.sh [version] [options]
#   version: Optional version tag (e.g., v1.0, draft-2024-10, final)
#            If not provided, will use: submission-YYYY-MM-DD
#   
# Options:
#   --no-git-tag      Skip creating git tag
#   --no-archive      Skip creating archive file
#   --draft           Mark as draft version
#   --final           Mark as final submission
#   --github-release  Create GitHub release (requires gh CLI)
#   --no-github       Skip GitHub release creation
#
# Author: Eduardo Sousa
# Last Updated: October 2025
#########################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
VERSION=""
CREATE_GIT_TAG=true
CREATE_ARCHIVE=true
IS_DRAFT=false
IS_FINAL=false
CREATE_GITHUB_RELEASE=false
RELEASE_DIR="releases"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
DATE_ONLY=$(date +"%Y-%m-%d")
GITHUB_REPO="edumi8/DMEI"

#########################################################################
# Helper Functions
#########################################################################

print_header() {
    echo -e "${BLUE}=================================================${NC}"
    echo -e "${BLUE}  TMDEI Thesis Release Orchestrator${NC}"
    echo -e "${BLUE}=================================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_step() {
    echo ""
    echo -e "${BLUE}>>> $1${NC}"
}

#########################################################################
# Parse Arguments
#########################################################################

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --no-git-tag)
                CREATE_GIT_TAG=false
                shift
                ;;
            --no-archive)
                CREATE_ARCHIVE=false
                shift
                ;;
            --draft)
                IS_DRAFT=true
                shift
                ;;
            --final)
                IS_FINAL=true
                shift
                ;;
            --github-release)
                CREATE_GITHUB_RELEASE=true
                shift
                ;;
            --no-github)
                CREATE_GITHUB_RELEASE=false
                shift
                ;;
            --help|-h)
                print_help
                exit 0
                ;;
            *)
                if [[ -z "$VERSION" ]]; then
                    VERSION="$1"
                else
                    print_error "Unknown option: $1"
                    exit 1
                fi
                shift
                ;;
        esac
    done

    # Set default version if not provided
    if [[ -z "$VERSION" ]]; then
        if [[ "$IS_FINAL" == true ]]; then
            VERSION="final-$DATE_ONLY"
        elif [[ "$IS_DRAFT" == true ]]; then
            VERSION="draft-$DATE_ONLY"
        else
            VERSION="submission-$DATE_ONLY"
        fi
    fi
}

print_help() {
    cat << EOF
TMDEI Thesis Release Script

Usage: ./release.sh [version] [options]

Arguments:
  version           Version tag (e.g., v1.0, draft-2024-10, final)
                    Default: submission-YYYY-MM-DD

Options:
  --no-git-tag      Skip creating git tag
  --no-archive      Skip creating archive file
  --draft           Mark as draft version (version: draft-YYYY-MM-DD)
  --final           Mark as final submission (version: final-YYYY-MM-DD)
  --github-release  Create GitHub release (requires gh CLI installed)
  --no-github       Explicitly skip GitHub release creation
  --help, -h        Show this help message

Examples:
  ./release.sh                          # Create submission-2024-10-25
  ./release.sh --draft                  # Create draft-2024-10-25
  ./release.sh --final                  # Create final-2024-10-25
  ./release.sh v1.0                     # Create v1.0 release
  ./release.sh v1.0 --github-release    # Create v1.0 with GitHub release
  ./release.sh --final --github-release # Final submission on GitHub
  ./release.sh review-1 --no-git-tag    # Create review-1 without git tag

EOF
}

#########################################################################
# Pre-flight Checks
#########################################################################

check_prerequisites() {
    print_step "Checking prerequisites..."

    # Check if we're in the right directory
    if [[ ! -f "main.tex" ]]; then
        print_error "main.tex not found. Please run this script from the thesis root directory."
        exit 1
    fi

    # Check for required tools
    local missing_tools=()
    
    command -v latexmk >/dev/null 2>&1 || missing_tools+=("latexmk")
    command -v git >/dev/null 2>&1 || missing_tools+=("git")
    command -v pdflatex >/dev/null 2>&1 || missing_tools+=("pdflatex")
    
    # Check for GitHub CLI if GitHub release is requested
    if [[ "$CREATE_GITHUB_RELEASE" == true ]]; then
        if ! command -v gh >/dev/null 2>&1; then
            print_warning "GitHub CLI (gh) not found. GitHub release will be skipped."
            print_info "Install with: sudo apt install gh (or see https://cli.github.com/)"
            CREATE_GITHUB_RELEASE=false
        else
            # Check if authenticated
            if ! gh auth status >/dev/null 2>&1; then
                print_warning "GitHub CLI not authenticated. GitHub release will be skipped."
                print_info "Authenticate with: gh auth login"
                CREATE_GITHUB_RELEASE=false
            fi
        fi
    fi
    
    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        print_error "Missing required tools: ${missing_tools[*]}"
        exit 1
    fi

    print_success "All prerequisites met"
}

#########################################################################
# Git Operations
#########################################################################

check_git_status() {
    print_step "Checking git repository status..."

    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_warning "Not a git repository. Skipping git operations."
        CREATE_GIT_TAG=false
        return
    fi

    # Check for uncommitted changes
    if [[ -n $(git status --porcelain) ]]; then
        print_warning "You have uncommitted changes:"
        git status --short
        echo ""
        read -p "Do you want to continue? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Release cancelled by user."
            exit 0
        fi
    else
        print_success "Working directory is clean"
    fi

    # Get current branch
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    CURRENT_COMMIT=$(git rev-parse --short HEAD)
    print_info "Current branch: $CURRENT_BRANCH"
    print_info "Current commit: $CURRENT_COMMIT"
}

create_git_tag() {
    if [[ "$CREATE_GIT_TAG" != true ]]; then
        return
    fi

    print_step "Creating git tag..."

    # Check if tag already exists
    if git rev-parse "$VERSION" >/dev/null 2>&1; then
        print_warning "Tag '$VERSION' already exists."
        read -p "Do you want to overwrite it? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git tag -d "$VERSION"
            print_info "Deleted existing tag"
        else
            print_error "Cannot create release with existing tag"
            exit 1
        fi
    fi

    # Create annotated tag
    TAG_MESSAGE="Release $VERSION - $(date '+%Y-%m-%d %H:%M:%S')"
    if [[ "$IS_FINAL" == true ]]; then
        TAG_MESSAGE="$TAG_MESSAGE [FINAL SUBMISSION]"
    elif [[ "$IS_DRAFT" == true ]]; then
        TAG_MESSAGE="$TAG_MESSAGE [DRAFT]"
    fi

    git tag -a "$VERSION" -m "$TAG_MESSAGE"
    print_success "Created git tag: $VERSION"

    # Ask if user wants to push
    read -p "Do you want to push the tag to remote? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git push origin "$VERSION"
        print_success "Pushed tag to remote"
    fi
}

create_github_release() {
    if [[ "$CREATE_GITHUB_RELEASE" != true ]]; then
        return
    fi

    print_step "Creating GitHub release..."

    # Ensure tag exists and is pushed
    if ! git rev-parse "$VERSION" >/dev/null 2>&1; then
        print_error "Tag '$VERSION' does not exist. Cannot create GitHub release."
        return
    fi

    # Check if tag is pushed
    if ! git ls-remote --tags origin | grep -q "refs/tags/$VERSION"; then
        print_warning "Tag '$VERSION' is not pushed to remote."
        read -p "Do you want to push it now? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git push origin "$VERSION"
            print_success "Pushed tag to remote"
        else
            print_error "Cannot create GitHub release without pushed tag"
            return
        fi
    fi

    # Prepare release notes
    RELEASE_NOTES_FILE="$RELEASE_PATH/GITHUB_RELEASE_NOTES.md"
    
    cat > "$RELEASE_NOTES_FILE" << EOF
# TMDEI Thesis Release: $VERSION

**Title:** CI/CD Observability in Containerized Environments  
**Author:** Eduardo Sousa  
**Specialization:** Cybersecurity and Systems Administration  
**Institution:** Instituto Superior de Engenharia do Porto (ISEP)

## Release Information

- **Version:** $VERSION
- **Release Date:** $(date '+%Y-%m-%d %H:%M:%S')
- **Release Type:** $(if [[ "$IS_FINAL" == true ]]; then echo "🎓 **FINAL SUBMISSION**"; elif [[ "$IS_DRAFT" == true ]]; then echo "📝 Draft Version"; else echo "📄 Intermediate Submission"; fi)

## Git Information

- **Branch:** $CURRENT_BRANCH
- **Commit:** $CURRENT_COMMIT
- **Commit Message:** $(git log -1 --pretty=%B | head -n 1)

## Document Details

- **PDF Size:** $PDF_SIZE
- **Build Timestamp:** $TIMESTAMP

## Contents

This release includes:

1. **TMDEI_Thesis_${VERSION}_EduardoSousa.pdf** - The complete thesis document
2. **Source Files** - Complete LaTeX source code
3. **RELEASE_INFO.txt** - Detailed release metadata
4. **CHECKSUMS.txt** - File integrity checksums

## Keywords

CI/CD, Observability, Containers, Tracing, Logging, Monitoring

## Thesis Committee

- **Advisor:** Dr. Alexandre Bragança
- **Supervisor:** Dr. Joao Silva

---

## How to Use

### Reading the Thesis
Simply download and open \`TMDEI_Thesis_${VERSION}_EduardoSousa.pdf\`

### Rebuilding from Source
1. Download the source archive
2. Extract files
3. Navigate to the source directory
4. Run: \`make clean && make all\`

### Verifying Integrity
\`\`\`bash
sha256sum -c CHECKSUMS.txt
\`\`\`

---

$(if [[ "$IS_FINAL" == true ]]; then
    echo "## 🎓 Final Submission"
    echo ""
    echo "This is the final version submitted for thesis defense."
    echo ""
    echo "### Abstract"
    echo ""
    echo "Modern DevOps teams rely on CI/CD platforms to manage software delivery. This thesis"
    echo "explores the implementation of comprehensive observability practices in containerized"
    echo "CI/CD environments to improve reliability and system administration capabilities."
elif [[ "$IS_DRAFT" == true ]]; then
    echo "## 📝 Draft Version"
    echo ""
    echo "This is a draft version for review and feedback."
    echo ""
    echo "### Status"
    echo ""
    echo "This draft is being shared for advisor/supervisor review."
else
    echo "## 📄 Intermediate Submission"
    echo ""
    echo "This is an intermediate submission for progress review."
fi)

---

*For questions or feedback, please contact Eduardo Sousa*
EOF

    print_info "Generated release notes"

    # Create GitHub release
    RELEASE_TITLE="TMDEI Thesis - $VERSION"
    if [[ "$IS_FINAL" == true ]]; then
        RELEASE_TITLE="$RELEASE_TITLE [FINAL SUBMISSION]"
    elif [[ "$IS_DRAFT" == true ]]; then
        RELEASE_TITLE="$RELEASE_TITLE [DRAFT]"
    fi

    # Determine if it should be a pre-release
    PRERELEASE_FLAG=""
    if [[ "$IS_DRAFT" == true ]] || [[ "$VERSION" == *"draft"* ]] || [[ "$VERSION" == *"beta"* ]] || [[ "$VERSION" == *"alpha"* ]]; then
        PRERELEASE_FLAG="--prerelease"
    fi

    # Check if release already exists
    if gh release view "$VERSION" --repo "$GITHUB_REPO" >/dev/null 2>&1; then
        print_warning "GitHub release '$VERSION' already exists."
        read -p "Do you want to delete and recreate it? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            gh release delete "$VERSION" --repo "$GITHUB_REPO" --yes
            print_info "Deleted existing release"
        else
            print_error "Cannot create duplicate release"
            return
        fi
    fi

    # Create the release
    if gh release create "$VERSION" \
        --repo "$GITHUB_REPO" \
        --title "$RELEASE_TITLE" \
        --notes-file "$RELEASE_NOTES_FILE" \
        $PRERELEASE_FLAG \
        "$RELEASE_PATH/$PDF_NAME" \
        "$ARCHIVE_PATH" \
        "$RELEASE_PATH/RELEASE_INFO.txt" \
        "$RELEASE_PATH/CHECKSUMS.txt"; then
        
        print_success "GitHub release created successfully!"
        RELEASE_URL="https://github.com/$GITHUB_REPO/releases/tag/$VERSION"
        print_info "Release URL: $RELEASE_URL"
    else
        print_error "Failed to create GitHub release"
    fi
}

#########################################################################
# Build Operations
#########################################################################

clean_build() {
    print_step "Cleaning previous build artifacts..."
    
    make clean-all 2>/dev/null || make clean 2>/dev/null || true
    
    # Clean any remaining PDF
    rm -f main.pdf 2>/dev/null || true
    
    print_success "Build artifacts cleaned"
}

build_pdf() {
    print_step "Building PDF document..."
    
    # Try normal build first
    if make all 2>&1 | tee /tmp/build.log; then
        print_success "PDF built successfully"
    else
        # Check if PDF was created despite errors (common with glossary warnings)
        if [[ -f "main.pdf" ]]; then
            print_warning "Build completed with warnings, but PDF was created"
            print_info "This is normal if glossaries are not used"
        else
            print_error "PDF build failed. Please check the LaTeX errors above."
            cat /tmp/build.log | grep -i "error" | head -20
            exit 1
        fi
    fi

    # Verify PDF was created
    if [[ ! -f "main.pdf" ]]; then
        print_error "main.pdf was not created"
        exit 1
    fi

    # Get PDF info
    PDF_SIZE=$(du -h main.pdf | cut -f1)
    print_info "PDF size: $PDF_SIZE"
}

#########################################################################
# Release Package Creation
#########################################################################

create_release_directory() {
    print_step "Creating release directory..."

    # Create releases directory if it doesn't exist
    mkdir -p "$RELEASE_DIR"

    # Create specific release directory
    RELEASE_NAME="${VERSION}_${TIMESTAMP}"
    RELEASE_PATH="$RELEASE_DIR/$RELEASE_NAME"
    mkdir -p "$RELEASE_PATH"

    print_success "Release directory created: $RELEASE_PATH"
}

copy_release_files() {
    print_step "Copying release files..."

    # Copy main PDF with versioned name
    PDF_NAME="TMDEI_Thesis_${VERSION}_EduardoSousa.pdf"
    cp main.pdf "$RELEASE_PATH/$PDF_NAME"
    print_success "Copied PDF: $PDF_NAME"

    # Copy source files
    mkdir -p "$RELEASE_PATH/source"
    
    # Copy LaTeX source files
    cp main.tex "$RELEASE_PATH/source/"
    cp tmdei-style.cls "$RELEASE_PATH/source/"
    cp mainbibliography.bib "$RELEASE_PATH/source/"
    cp Makefile "$RELEASE_PATH/source/"
    cp latexmk.rc "$RELEASE_PATH/source/" 2>/dev/null || true
    
    # Copy chapter directories
    for chapter_dir in ch*/; do
        if [[ -d "$chapter_dir" ]]; then
            cp -r "$chapter_dir" "$RELEASE_PATH/source/"
        fi
    done

    # Copy frontmatter
    if [[ -d "frontmatter" ]]; then
        cp -r frontmatter "$RELEASE_PATH/source/"
    fi

    # Copy appendices
    if [[ -d "appendices" ]]; then
        cp -r appendices "$RELEASE_PATH/source/"
    fi

    print_success "Source files copied"
}

generate_release_info() {
    print_step "Generating release information..."

    INFO_FILE="$RELEASE_PATH/RELEASE_INFO.txt"

    cat > "$INFO_FILE" << EOF
========================================================================
TMDEI Thesis Release Information
========================================================================

Title:          CI/CD Observability in Containerized Environments
Author:         Eduardo Sousa
Specialization: Cybersecurity And Systems Administration
Institution:    Instituto Superior de Engenharia do Porto (ISEP)

Release Information:
-------------------
Version:        $VERSION
Release Date:   $(date '+%Y-%m-%d %H:%M:%S')
Build Type:     $(if [[ "$IS_FINAL" == true ]]; then echo "FINAL SUBMISSION"; elif [[ "$IS_DRAFT" == true ]]; then echo "DRAFT"; else echo "INTERMEDIATE SUBMISSION"; fi)

Git Information:
---------------
$(if git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Branch:         $CURRENT_BRANCH"
    echo "Commit:         $CURRENT_COMMIT"
    echo "Commit Message: $(git log -1 --pretty=%B | head -n 1)"
else
    echo "Not a git repository"
fi)

Document Statistics:
-------------------
PDF Size:       $PDF_SIZE
Build Time:     $TIMESTAMP

Contents:
---------
- TMDEI_Thesis_${VERSION}_EduardoSousa.pdf (Main document)
- source/ (Complete LaTeX source files)
- RELEASE_INFO.txt (This file)
- CHECKSUMS.txt (File integrity checksums)

Advisor:        Dr. Alexandre Bragança
Supervisor:     Dr. Joao Silva

Keywords:       CI/CD, Observability, Containers, Tracing, Logging, Monitoring

========================================================================

Build Instructions:
------------------
To rebuild this document from source:
1. Ensure you have a complete LaTeX distribution installed (TeXLive recommended)
2. Navigate to the source/ directory
3. Run: make clean && make all
4. The PDF will be generated as main.pdf

Required LaTeX Packages:
- babel, biblatex, booktabs, caption, graphicx, listings
- pgfplots, tikz, algorithm, glossaries
(See README.md for complete list)

========================================================================
For questions or issues, contact: Eduardo Sousa
========================================================================
EOF

    print_success "Release information generated"
}

generate_checksums() {
    print_step "Generating checksums..."

    CHECKSUM_FILE="$RELEASE_PATH/CHECKSUMS.txt"

    (
        cd "$RELEASE_PATH"
        sha256sum "$PDF_NAME" > CHECKSUMS.txt
        find source -type f -exec sha256sum {} \; >> CHECKSUMS.txt
    )

    print_success "Checksums generated"
}

create_archive() {
    if [[ "$CREATE_ARCHIVE" != true ]]; then
        return
    fi

    print_step "Creating archive file..."

    ARCHIVE_NAME="${RELEASE_NAME}.zip"
    ARCHIVE_PATH="$RELEASE_DIR/$ARCHIVE_NAME"

    (
        cd "$RELEASE_DIR"
        zip -r "$ARCHIVE_NAME" "$RELEASE_NAME" > /dev/null
    )

    ARCHIVE_SIZE=$(du -h "$ARCHIVE_PATH" | cut -f1)
    print_success "Archive created: $ARCHIVE_NAME ($ARCHIVE_SIZE)"
}

#########################################################################
# Summary
#########################################################################

print_summary() {
    echo ""
    echo -e "${GREEN}=================================================${NC}"
    echo -e "${GREEN}  Release Created Successfully!${NC}"
    echo -e "${GREEN}=================================================${NC}"
    echo ""
    echo -e "Version:        ${BLUE}$VERSION${NC}"
    echo -e "Release Path:   ${BLUE}$RELEASE_PATH${NC}"
    echo -e "PDF Name:       ${BLUE}$PDF_NAME${NC}"
    
    if [[ "$CREATE_ARCHIVE" == true ]]; then
        echo -e "Archive:        ${BLUE}$ARCHIVE_PATH${NC}"
    fi
    
    if [[ "$CREATE_GIT_TAG" == true ]]; then
        echo -e "Git Tag:        ${BLUE}$VERSION${NC}"
    fi
    
    if [[ "$CREATE_GITHUB_RELEASE" == true ]]; then
        RELEASE_URL="https://github.com/$GITHUB_REPO/releases/tag/$VERSION"
        echo -e "GitHub Release: ${BLUE}$RELEASE_URL${NC}"
    fi
    
    echo ""
    echo -e "${YELLOW}Next Steps:${NC}"
    echo "1. Review the generated PDF in: $RELEASE_PATH"
    echo "2. Check RELEASE_INFO.txt for complete details"
    
    if [[ "$CREATE_GITHUB_RELEASE" == true ]]; then
        echo "3. View GitHub release: https://github.com/$GITHUB_REPO/releases/tag/$VERSION"
        echo "4. Share the GitHub release link with your supervisor"
    elif [[ "$CREATE_ARCHIVE" == true ]]; then
        echo "3. Submit the archive file: $ARCHIVE_NAME"
    else
        echo "3. Submit the PDF file: $PDF_NAME"
    fi
    
    if [[ "$IS_FINAL" == true ]]; then
        echo ""
        echo -e "${GREEN}🎓 This is marked as your FINAL SUBMISSION. Good luck!${NC}"
    fi
    
    echo ""
}

#########################################################################
# Main Execution
#########################################################################

main() {
    print_header
    
    parse_arguments "$@"
    
    print_info "Creating release: $VERSION"
    echo ""
    
    check_prerequisites
    check_git_status
    clean_build
    build_pdf
    create_release_directory
    copy_release_files
    generate_release_info
    generate_checksums
    create_archive
    create_git_tag
    create_github_release
    
    print_summary
}

# Run main function with all arguments
main "$@"
