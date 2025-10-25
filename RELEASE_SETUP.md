# Thesis Release System - Complete Setup

## ✅ What's Been Created

Your thesis now has a comprehensive release orchestration system that automates the entire submission process and integrates with GitHub for easy sharing.

### Core Files

1. **`release.sh`** - Main orchestration script
   - Automated build and packaging
   - Git integration with tagging
   - GitHub release creation
   - Checksum generation
   - Release documentation

2. **`Makefile`** (updated) - Convenient shortcuts
   - `make release` - Standard release
   - `make release-draft` - Draft release
   - `make release-final` - Final submission
   - `make github-release` - Standard with GitHub
   - `make github-draft` - Draft on GitHub
   - `make github-final` - Final on GitHub

3. **Documentation**
   - `RELEASE_GUIDE.md` - Comprehensive guide
   - `RELEASE_QUICK_REF.md` - Quick reference card
   - `docs/email_templates.md` - Email templates for submissions

4. **`.gitignore`** (updated) - Ignores release artifacts

## 🚀 Quick Start

### First Time Setup

1. **Make script executable** (already done):
   ```bash
   chmod +x release.sh
   ```

2. **Optional: Install GitHub CLI** (for GitHub releases):
   ```bash
   sudo apt install gh
   gh auth login
   ```

### Creating Your First Release

#### Option 1: Local Release Only
```bash
./release.sh --draft
```

#### Option 2: GitHub Release (Recommended)
```bash
./release.sh --draft --github-release
```

The GitHub release will:
- Upload your PDF automatically
- Create formatted release notes
- Provide a shareable URL
- Host all files permanently

## 📋 Common Workflows

### Weekly Progress Submission
```bash
./release.sh week-10 --no-git-tag
```

### Draft for Supervisor Review
```bash
./release.sh --draft --github-release
make github-draft  # Shortcut
```
Share the GitHub URL with your supervisor - no email attachments needed!

### Final Defense Submission
```bash
./release.sh --final --github-release
make github-final  # Shortcut
```

### Custom Version
```bash
./release.sh v1.0 --github-release
./release.sh supervisor-review-oct
```

## 🎯 GitHub Release Benefits

### Why Use GitHub Releases?

✅ **Easy Sharing**
- One URL instead of email attachments
- No file size limits
- Professional presentation

✅ **Version Control**
- All versions in one place
- Easy to compare releases
- Permanent archival

✅ **Professional**
- Automatic release notes
- Formatted metadata
- Clean interface

✅ **Accessible**
- Committee members can download anytime
- No need for email chains
- Direct download links

### Example GitHub Release URL
```
https://github.com/edumi8/DMEI/releases/tag/final-2024-10-25
```

## 📦 What Gets Created

```
releases/
└── submission-2024-10-25_14-30-00/
    ├── TMDEI_Thesis_submission-2024-10-25_EduardoSousa.pdf
    ├── RELEASE_INFO.txt
    ├── CHECKSUMS.txt
    ├── GITHUB_RELEASE_NOTES.md  (if using --github-release)
    └── source/
        ├── main.tex
        ├── mainbibliography.bib
        ├── tmdei-style.cls
        ├── Makefile
        ├── ch1/, ch2/, ch3/
        ├── frontmatter/
        └── appendices/

releases/submission-2024-10-25_14-30-00.zip  (archive)
```

Plus, if using `--github-release`:
- GitHub release created at: `https://github.com/edumi8/DMEI/releases/tag/[version]`
- All files uploaded and hosted by GitHub
- Automatic release notes with metadata

## 🔧 GitHub CLI Setup (One-Time)

If you want to use GitHub releases:

```bash
# Install GitHub CLI
sudo apt install gh

# Authenticate (follow prompts)
gh auth login

# Verify
gh auth status
```

You only need to do this once. After that, the release script will automatically create GitHub releases when you use the `--github-release` flag.

## 📖 Available Options

| Option             | Description              |
|--------------------|--------------------------|
| `--draft`          | Mark as draft version    |
| `--final`          | Mark as final submission |
| `--github-release` | Create GitHub release    |
| `--no-github`      | Skip GitHub release      |
| `--no-git-tag`     | Don't create git tag     |
| `--no-archive`     | Don't create ZIP file    |

## 🎓 Thesis Workflow Example

### Month 1-2: Early Drafts
```bash
./release.sh chapter1-draft --no-git-tag
./release.sh chapter2-draft --no-git-tag
```

### Month 3-4: Progress Reviews
```bash
./release.sh progress-review-march --github-release
# Share URL with supervisor
```

### Month 5-6: Committee Review
```bash
./release.sh committee-draft --github-release
# Share URL with entire committee
```

### Month 7: Final Submission
```bash
./release.sh --final --github-release
make github-final  # Alternative

# Share final GitHub release URL for defense
```

## 📧 Sharing with Supervisor

### Old Way ❌
1. Build PDF manually
2. Create ZIP file
3. Upload to email
4. Wait for supervisor to download
5. Repeat for each version

### New Way ✅
```bash
./release.sh --draft --github-release
```
Then send this email:

```
Dear Dr. Bragança,

I've prepared a new draft of my thesis. You can access it here:
https://github.com/edumi8/DMEI/releases/tag/draft-2024-10-25

The release includes:
- Complete PDF
- Source files
- Release notes with metadata

Best regards,
Eduardo
```

## 🔍 Verifying Releases

### Check Release Info
```bash
cat releases/[version]_[timestamp]/RELEASE_INFO.txt
```

### Verify File Integrity
```bash
cd releases/[version]_[timestamp]/
sha256sum -c CHECKSUMS.txt
```

### View GitHub Releases
```bash
gh release list --repo edumi8/DMEI
gh release view [version] --repo edumi8/DMEI
```

## 🛠️ Troubleshooting

### Script Won't Run
```bash
chmod +x release.sh
```

### Build Fails
```bash
make clean
make all
# Fix any LaTeX errors
./release.sh
```

### GitHub CLI Not Found
```bash
sudo apt install gh
gh auth login
```

### Tag Already Exists
The script will ask if you want to overwrite it. Choose yes to proceed.

## 📚 Documentation Files

- **RELEASE_GUIDE.md** - Comprehensive documentation
- **RELEASE_QUICK_REF.md** - Quick reference card
- **docs/email_templates.md** - Email templates for submissions
- **README.md** - Updated with release instructions

## 💡 Pro Tips

1. **Always commit before releasing**
   ```bash
   git add .
   git commit -m "Complete Chapter 3"
   ./release.sh chapter3-complete
   ```

2. **Use meaningful version names**
   - ✅ `supervisor-feedback-oct`
   - ✅ `pre-defense-review`
   - ✅ `v1.0`, `v2.0`
   - ❌ `test`, `final2`, `really-final`

3. **Use GitHub releases for important milestones**
   - Committee reviews
   - Supervisor submissions
   - Final defense

4. **Keep local releases as backups**
   - Don't delete `releases/` directory
   - Regular backups to cloud storage

5. **Test the PDF before sharing**
   - Always open and review the generated PDF
   - Check all figures render correctly
   - Verify bibliography formatting

## 🎉 Summary

You now have a professional release system that:

✅ Automates thesis compilation and packaging
✅ Creates versioned releases with metadata
✅ Integrates with Git for version control
✅ Creates GitHub releases for easy sharing
✅ Generates checksums for integrity verification
✅ Provides professional release notes
✅ Simplifies supervisor communication

### Next Steps

1. Try creating your first release:
   ```bash
   ./release.sh test-release --draft
   ```

2. Optional: Set up GitHub CLI for releases:
   ```bash
   sudo apt install gh
   gh auth login
   ```

3. Read the full guide when needed:
   - [RELEASE_GUIDE.md](RELEASE_GUIDE.md) - Full documentation
   - [RELEASE_QUICK_REF.md](RELEASE_QUICK_REF.md) - Quick reference

4. When ready for first real submission:
   ```bash
   git add .
   git commit -m "First complete draft"
   ./release.sh --draft --github-release
   ```

## 📬 Support

For detailed examples and troubleshooting, see:
- [RELEASE_GUIDE.md](RELEASE_GUIDE.md)
- [RELEASE_QUICK_REF.md](RELEASE_QUICK_REF.md)
- [docs/email_templates.md](docs/email_templates.md)

Good luck with your thesis! 🎓
