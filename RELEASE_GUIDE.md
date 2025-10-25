# Thesis Release Guide

This guide explains how to use the release orchestration script to prepare your thesis for submission to your teacher/supervisor.

## Quick Start

### Basic Release
```bash
./release.sh
```
This creates a standard submission with automatic versioning: `submission-YYYY-MM-DD`

### Draft Release
```bash
./release.sh --draft
# or
make release-draft
```
Creates a draft release: `draft-YYYY-MM-DD`

### Final Submission
```bash
./release.sh --final
# or
make release-final
```
Creates your final submission: `final-YYYY-MM-DD`

### GitHub Release (Recommended for Easy Sharing)
```bash
./release.sh --github-release
# or for drafts
./release.sh --draft --github-release
make github-draft
# or for final
./release.sh --final --github-release
make github-final
```
Creates a release on GitHub with automatic file hosting and shareable links.

### Custom Version
```bash
./release.sh v1.0
./release.sh review-1
./release.sh supervisor-feedback-oct
./release.sh v2.0 --github-release  # With GitHub release
```

## What the Script Does

The release script orchestrates the entire submission process:

1. **Pre-flight Checks**
   - Verifies you're in the correct directory
   - Checks for required tools (latexmk, pdflatex, git)
   - Ensures all prerequisites are met

2. **Git Status Check**
   - Shows uncommitted changes (if any)
   - Displays current branch and commit
   - Warns you before proceeding with dirty working directory

3. **Clean Build**
   - Removes all previous build artifacts
   - Ensures a fresh compilation
   - Cleans temporary LaTeX files

4. **PDF Compilation**
   - Compiles the complete thesis
   - Reports any LaTeX errors
   - Verifies PDF creation

5. **Release Package Creation**
   - Creates versioned release directory
   - Copies PDF with proper naming convention
   - Includes all source files
   - Preserves chapter structure and assets

6. **Documentation Generation**
   - Creates detailed release information file
   - Includes git metadata
   - Documents build statistics
   - Provides rebuild instructions

7. **Integrity Verification**
   - Generates SHA256 checksums
   - Ensures file integrity
   - Allows verification after transfer

8. **Archive Creation**
   - Creates a ZIP archive
   - Ready for email or upload
   - Contains complete submission package

9. **Git Tagging** (optional)
   - Creates annotated git tag
   - Marks specific submission points
   - Optionally pushes to remote

10. **GitHub Release Creation** (optional, requires `--github-release` flag)
    - Creates public release on GitHub
    - Uploads PDF and archive files
    - Generates formatted release notes
    - Provides shareable URL for easy access
    - Marks as pre-release if draft

## Options

### `--draft`
Marks the release as a draft version. Useful for early submissions or feedback rounds.

**Example:**
```bash
./release.sh --draft
```
**Output:** `draft-2024-10-25/`

### `--final`
Marks the release as your final submission. Use this for your definitive delivery.

**Example:**
```bash
./release.sh --final
```
**Output:** `final-2024-10-25/`

### `--no-git-tag`
Skips creating a git tag. Useful if you don't want to tag every intermediate submission.

**Example:**
```bash
./release.sh review-2 --no-git-tag
```

### `--no-archive`
Skips creating the ZIP archive. Use if you only need the PDF or want to create a custom archive.

**Example:**
```bash
./release.sh --no-archive
```

### `--github-release`
Creates a GitHub release with automatic file hosting. **This is the recommended way to share your thesis** with supervisors and committee members.

**Requirements:**
- GitHub CLI (`gh`) must be installed
- Must be authenticated with GitHub

**Example:**
```bash
./release.sh v1.0 --github-release
./release.sh --final --github-release
make github-final
```

**Benefits:**
- No email attachment size limits
- Professional presentation
- Easy version tracking
- Permanent archival
- Direct download links
- Automatic release notes

### `--no-github`
Explicitly skips GitHub release creation even if configured.

**Example:**
```bash
./release.sh --no-github
```

## GitHub CLI Setup

### Installation

**Ubuntu/Debian/WSL:**
```bash
sudo apt install gh
```

**macOS:**
```bash
brew install gh
```

**Windows:**
Download from: https://cli.github.com/

### Authentication (One-Time Setup)

```bash
# Login to GitHub
gh auth login

# Follow the prompts:
# 1. Select GitHub.com
# 2. Select HTTPS or SSH
# 3. Authenticate via web browser or token

# Verify authentication
gh auth status
```

You only need to do this once. The script will automatically detect if you're authenticated.

## Usage Examples

### Weekly Progress Submission
```bash
./release.sh week-8 --no-git-tag
```

### Supervisor Review
```bash
./release.sh supervisor-review-1
```

### Committee Submission
```bash
./release.sh committee-draft --draft
```

### Final Defense
```bash
./release.sh --final
```

### Mid-term Delivery
```bash
./release.sh midterm-2024-10
```

### Revision After Feedback
```bash
./release.sh v1.1-revised
./release.sh v1.1-revised --github-release  # Share on GitHub
```

### Sharing with Committee
```bash
# Create release on GitHub for easy access
./release.sh committee-submission --github-release

# Share this URL with committee:
# https://github.com/edumi8/DMEI/releases/tag/committee-submission
```

## Release Directory Structure

After running the script, you'll find:

```
releases/
└── submission-2024-10-25_14-30-00/
    ├── TMDEI_Thesis_submission-2024-10-25_EduardoSousa.pdf
    ├── RELEASE_INFO.txt
    ├── CHECKSUMS.txt
    └── source/
        ├── main.tex
        ├── tmdei-style.cls
        ├── mainbibliography.bib
        ├── Makefile
        ├── ch1/
        ├── ch2/
        ├── ch3/
        ├── frontmatter/
        └── appendices/
```

### File Descriptions

- **PDF**: Your compiled thesis with versioned naming
- **RELEASE_INFO.txt**: Complete metadata about the release
- **CHECKSUMS.txt**: SHA256 checksums for integrity verification
- **source/**: Complete LaTeX source files for rebuilding

## Integration with Makefile

The script is integrated into your Makefile for convenience:

```bash
# Standard release
make release

# Draft release
make release-draft

# Final release
make release-final
```

## Best Practices

### Before Each Submission

1. **Review your changes**
   ```bash
   git status
   git diff
   ```

2. **Commit your work**
   ```bash
   git add .
   git commit -m "Descriptive commit message"
   ```

3. **Run the release script**
   ```bash
   ./release.sh --draft  # or appropriate version
   ```

4. **Verify the PDF**
   - Open the generated PDF
   - Check all chapters render correctly
   - Verify figures and tables
   - Review bibliography formatting

5. **Review RELEASE_INFO.txt**
   - Confirm metadata is correct
   - Check git information
   - Verify document statistics

### Version Naming Conventions

- **Draft submissions**: `draft-YYYY-MM-DD` or `draft-v1`, `draft-v2`
- **Supervisor reviews**: `supervisor-YYYY-MM-DD` or `supervisor-review-N`
- **Committee submissions**: `committee-YYYY-MM-DD`
- **Intermediate versions**: `v1.0`, `v1.1`, `v1.2`
- **Final submission**: `final-YYYY-MM-DD` or simply `final`

### Git Workflow

1. Work on your thesis
2. Commit changes regularly
3. Create release for submission
4. Tag important milestones
5. Push tags to remote backup

```bash
git add .
git commit -m "Complete Chapter 3 - Methodology"
./release.sh chapter3-complete
git push origin main
git push origin chapter3-complete  # if tagged
```

## Troubleshooting

### "main.tex not found"
**Solution:** Run the script from the thesis root directory.

### "Missing required tools"
**Solution:** Install missing tools:
```bash
# On Ubuntu/Debian
sudo apt-get install texlive-full latexmk

# On Windows (WSL)
sudo apt-get update
sudo apt-get install texlive-full
```

### "PDF build failed"
**Solution:** 
1. Check LaTeX errors in the output
2. Run `make clean && make all` manually
3. Fix LaTeX errors in your source files
4. Run release script again

### "Uncommitted changes warning"
**Solution:**
- Commit your changes: `git add . && git commit -m "Message"`
- Or proceed anyway if you want to release current state

### "Tag already exists"
**Solution:**
- Use a different version name
- Or choose to overwrite when prompted
- Or delete the tag first: `git tag -d version-name`

### Permission Denied
**Solution:** Make script executable:
```bash
chmod +x release.sh
```

## What to Submit

Depending on your supervisor's preference:

### Option 1: ZIP Archive
Submit the generated ZIP file:
```
releases/submission-2024-10-25_14-30-00.zip
```

### Option 2: PDF Only
Submit just the PDF:
```
releases/submission-2024-10-25_14-30-00/TMDEI_Thesis_submission-2024-10-25_EduardoSousa.pdf
```

### Option 3: Complete Directory
Share the entire release directory (via cloud storage):
```
releases/submission-2024-10-25_14-30-00/
```

## Verifying Integrity

Recipients can verify file integrity using the checksums:

```bash
cd releases/submission-2024-10-25_14-30-00/
sha256sum -c CHECKSUMS.txt
```

All files should show "OK" status.

## Advanced Usage

### Custom Release without Archive
```bash
./release.sh custom-version --no-archive --no-git-tag
```

### Multiple Releases in One Day
The timestamp ensures unique directory names:
```bash
./release.sh morning-version    # 09:00
./release.sh afternoon-version  # 14:00
./release.sh evening-version    # 20:00
```

### Emergency Quick Release
```bash
./release.sh emergency-fix --no-git-tag --no-archive
```

## Cleaning Up Old Releases

To save disk space, periodically clean old releases:

```bash
# List releases
ls -lh releases/

# Remove specific release
rm -rf releases/draft-2024-09-15_*

# Keep only final releases
find releases/ -type d -name 'draft-*' -exec rm -rf {} +
```

**Warning:** Be careful when deleting releases. Make sure you have backups.

## Integration with Cloud Storage

### Upload to OneDrive/Google Drive
```bash
# After release
cp releases/submission-2024-10-25_14-30-00.zip ~/OneDrive/Thesis/
```

### Email Submission
The ZIP archive is email-ready. Attach it to your submission email.

### Git Remote Backup
```bash
# Tag important submissions
./release.sh final
git push origin final

# Clone anywhere to retrieve
git clone <repository-url>
git checkout final
```

## Support

For issues with the release script:
1. Check this guide
2. Review error messages carefully
3. Ensure all prerequisites are installed
4. Contact your supervisor if problems persist

## Changelog

### Version 1.0 (October 2025)
- Initial release
- Automated build and packaging
- Git integration
- Archive creation
- Checksum verification
- Release information generation
