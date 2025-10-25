# Quick Release Reference Card

## Most Common Commands

```bash
# Standard submission (automatic dating)
./release.sh
make release

# Draft for supervisor review
./release.sh --draft
make release-draft

# Final submission
./release.sh --final
make release-final

# GitHub Releases (requires gh CLI)
./release.sh --github-release          # Standard with GitHub release
./release.sh --draft --github-release  # Draft on GitHub
make github-draft
./release.sh --final --github-release  # Final on GitHub
make github-final

# Custom version name
./release.sh supervisor-review-1
./release.sh v1.0 --github-release
./release.sh midterm-submission
```

## What Gets Created

```
releases/
└── [version]_[timestamp]/
    ├── TMDEI_Thesis_[version]_EduardoSousa.pdf  ← Submit this
    ├── RELEASE_INFO.txt                          ← Metadata
    ├── CHECKSUMS.txt                             ← Verification
    ├── GITHUB_RELEASE_NOTES.md                   ← GitHub notes
    └── source/                                   ← Full LaTeX source

releases/[version]_[timestamp].zip                ← Or submit this archive

GitHub Release (if --github-release used):
https://github.com/edumi8/DMEI/releases/tag/[version]
```

## Workflow

1. **Make your changes** → Edit thesis files
2. **Commit your work** → `git add . && git commit -m "Description"`
3. **Create release** → `./release.sh --draft --github-release`
4. **Verify PDF** → Check `releases/*/TMDEI_Thesis_*.pdf`
5. **Share link** → Send GitHub release URL to supervisor

## Options Quick Guide

| Option             | Effect                                              |
|--------------------|-----------------------------------------------------|
| `--draft`          | Creates draft-YYYY-MM-DD version                    |
| `--final`          | Creates final-YYYY-MM-DD version (use for defense!) |
| `--github-release` | Creates GitHub release (requires gh CLI)            |
| `--no-github`      | Skip GitHub release creation                        |
| `--no-git-tag`     | Don't create git tag                                |
| `--no-archive`     | Don't create ZIP file                               |

## GitHub CLI Setup

```bash
# Install GitHub CLI (one-time setup)
sudo apt install gh
# or download from: https://cli.github.com/

# Authenticate (one-time setup)
gh auth login

# Verify authentication
gh auth status
```

## Troubleshooting

| Problem                     | Solution                                       |
|-----------------------------|------------------------------------------------|
| "main.tex not found"        | Run from thesis root directory                 |
| "Permission denied"         | `chmod +x release.sh`                          |
| Build fails                 | Fix LaTeX errors, run `make clean && make all` |
| Uncommitted changes warning | Commit first or proceed anyway                 |
| "gh: command not found"     | Install GitHub CLI: `sudo apt install gh`      |
| "gh not authenticated"      | Run `gh auth login`                            |

## Examples for Different Scenarios

```bash
# Weekly progress update
./release.sh week-10 --no-git-tag

# After supervisor feedback
./release.sh revision-after-feedback-oct

# Before defense (share on GitHub)
./release.sh pre-defense-draft --github-release

# Final defense version (public on GitHub)
./release.sh --final --github-release
make github-final

# Emergency fix
./release.sh hotfix-chapter3 --no-archive

# Milestone release on GitHub
./release.sh v1.0 --github-release

# Create release without GitHub
./release.sh v1.0 --no-github
```

## File Locations

- **Releases**: `releases/` directory
- **PDFs**: `releases/[version]_[timestamp]/TMDEI_Thesis_*.pdf`
- **Archives**: `releases/[version]_[timestamp].zip`
- **Documentation**: `releases/[version]_[timestamp]/RELEASE_INFO.txt`
- **GitHub**: `https://github.com/edumi8/DMEI/releases/tag/[version]`

## GitHub Release Benefits

✓ Easy sharing via URL (no email attachments)
✓ Version history visible to everyone
✓ Automatic file hosting
✓ Professional presentation
✓ Permanent archival
✓ Direct download links for committee
✓ Release notes with metadata

## Tips

✓ Always verify the PDF before submitting
✓ Keep release archives as backups
✓ Use meaningful version names for tracking
✓ Tag final submissions for history
✓ Check RELEASE_INFO.txt for metadata
✓ Use GitHub releases for easy sharing with committee
✓ Install GitHub CLI: `sudo apt install gh` or visit https://cli.github.com/
✓ Authenticate once: `gh auth login`
✓ GitHub releases are public by default
✓ Use `--draft` flag for pre-releases on GitHub

## Need Help?

See full documentation: [RELEASE_GUIDE.md](RELEASE_GUIDE.md)
