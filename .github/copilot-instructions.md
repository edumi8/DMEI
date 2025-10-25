# AI Assistant Instructions for TMDEI LaTeX Dissertation Template

# Bibliography Review Workflow

When you request a bibliography review (e.g., for `mainbibliography.bib`), the assistant must:

1. **Harvard Style & BibTeX Compliance**: Check each entry for correct BibTeX fields and Harvard citation style (author initials, year in parentheses, title, etc.).
2. **Citation Key Validation**: Ensure every citation key matches those used in all `.tex` files (no missing or unused keys).
3. **Duplicate & Missing Entries**: Identify duplicate keys and warn about missing references.
4. **Formatting Consistency**: Suggest improvements for field formatting, capitalization, punctuation, and LaTeX encoding of special characters.
5. **Grammar & Spelling**: Check for grammar and spelling errors in BibTeX entry fields (title, abstract, etc.).
6. **Warnings**: Clearly warn about any issues found (style, missing, duplicates, formatting, grammar).

Always follow all steps above when the user requests a bibliography review, and notify the user of any problems or improvements needed.

**Tip:** Run a LaTeX linter or spell checker before submission to catch errors early.

Always follow all steps above when the user requests a bibliography review, and notify the user of any problems or improvements needed.

## Document Structure

### Core Components

- `main.tex`: Primary document with configuration and structure

  - Thesis metadata (title, author, advisors)
  - Language settings (english/portuguese)
  - Bibliography configuration
  - Chapter inclusions
  - Document options (11pt, paper size, etc.)

- `tmdei-style.cls`: Style class defining formatting

  - Page layout and margins
  - Font settings
  - Header/footer design
  - Section numbering and depth
  - Custom environments

- `frontmatter/`: Preliminary content

  - Resumo (max 1000 words Portuguese)
  - Acknowledgments
  - Lists (figures, tables, etc.)
  - `glossary.tex`: Terminology and acronyms

- `ch[1-N]/`: Chapters organization

  - Main text in `chapterN.tex`
  - Assets in `chapter/assets/`

    1. Overview/Introduction
    2. Main content sections
    3. Summary/Conclusions

  - Technical details
  - Extended results
  - Supplementary materials

  - Harvard citation style guide
  - Technical writing resources

## Content Standards

- Active voice preferred
- No colloquialisms

### Abstract Guidelines

- English Abstract:
  - Maximum 200 words
  - Problem statement
  - Methodology summary
  - Key findings
  - Main conclusions
- Portuguese Resumo:
  - Maximum 1000 words
  - Extended description
  - Full methodology
  - Detailed results

### Bibliography Standards

- Harvard citation style
- BibTeX format in `mainbibliography.bib`
- Citation commands:
  - Basic: `\parencite{key}` → (Author, Year)
  - Text: `\textcite{key}` → Author (Year)
  - Multiple: `\parencite{key1,key2}` → (Author1, Year; Author2, Year)
  - Page numbers: `\parencite[p.~99]{key}` → (Author, Year, p. 99)

### Research Context

#### Problem Domain

- CI/CD Observability Challenges
  - Containerized environments
  - Limited access rights
  - Cross-platform compatibility
  - Integration requirements

#### Technical Implementation

- Container-level monitoring
  - Resource metrics
  - Service health
  - Performance data
- Distributed tracing
  - Request flows
  - Dependencies
  - Bottlenecks
- Log aggregation
  - Error patterns
  - System behavior
  - Troubleshooting data

## Technical Elements

### Mathematical Content

- Use `equation` environment for numbered equations:
  ```latex
  \begin{equation}
    y = mx + b
    \label{eq:linear}
  \end{equation}
  ```
- Inline math with `$...$`
- Multi-line equations with `align` environment
- Define symbols in nomenclature
- Use `\SI{}` for measurements

### Code Listings

- Use language-specific formatting:
  ```java
  public class Example {
      // ...existing code...
  }
  ```
- Include captions and labels
- Reference with `\ref{lst:label}`

Example table:

```latex
\begin{table}[htbp]
  \centering
  \caption{Sample Data}
  \label{tab:data}
  A & 10 & +5\% \\
  B & 20 & -2\% \\
  \bottomrule
\end{tabular}
\end{table}
```

```
  \includegraphics[width=0.8\textwidth]{path/to/image}
  \caption{Descriptive caption}
  \label{fig:identifier}
\end{figure}
```

## Build Workflow

### Development Process

1. Write content in appropriate directories
2. Manage references in `mainbibliography.bib`
3. Build with `make` command:
   ```bash
   make        # Build document
   make clean  # Remove temporary files
   ```
4. Check `build/` for intermediate files
5. Final PDF in root directory

### Required Tools

- TeXLive distribution
- GNU Make (Linux/macOS)
- Required packages:
  - babel (language support)
  - biblatex (bibliography)
  - glossaries (terminology)
  - graphicx (images)
  - listings (code)
  - siunitx (units)

### Online Alternatives

- Overleaf
  - Professional online editor
  - Real-time collaboration
  - Note: Free tier has limitations
- Crixet
  - Alternative platform
  - Good for Windows users
  - Browser-based editing

## Common Issues

### Build Problems

- Clean build required after:
  - Language changes
  - Glossary updates
  - Bibliography changes
- Windows path issues:
  - Use forward slashes
  - Keep paths relative
  - Avoid spaces in names

### Content Challenges

- Abstract length:
  - English: Stay under 200 words
  - Portuguese: Focus on key points in 1000 words
- Figure placement:
  - Use [htbp] options
  - Consider float barriers
  - Keep figures near references
- Table formatting:
  - Use booktabs for lines
  - Align numbers properly
  - Handle long tables correctly

### Cross-referencing

- Label all important elements:
  - Chapters: `\label{chap:name}`
  - Sections: `\label{sec:name}`
  - Figures: `\label{fig:name}`
  - Tables: `\label{tab:name}`
  - Equations: `\label{eq:name}`
- Reference format:
  - Chapters: Chapter~\ref{chap:name}
  - Sections: Section~\ref{sec:name}
  - Use \autoref{} when possible

## Style Guide

### Text Formatting

### Glossary & Nomenclature Rules

- Define all acronyms in `glossary.tex` using `\newacronym{key}{abbr}{Full term}` (use consistent capitalization)
- Reference using `\gls{key}`
- Include nomenclature with `\nomenclature{symbol}{definition}`
- Regenerate glossary after edits: `make glossary`

#### General Rules

- Use consistent typesetting for terms throughout
- Define acronyms at first use with `\gls{}`
- Mark inline code with `\code{}`
- Mark file names with `\file{}`
- Mark command options with `\option{}`

#### Figures and Tables

- Center all figures and tables
- Provide descriptive captions
- Reference using `\autoref{}`
- Example:
  ```latex
  \begin{figure}[htbp]
    \centering
    \includegraphics[width=0.8\textwidth]{figures/diagram}
    \caption{System Architecture Overview}
    \label{fig:system-arch}
  \end{figure}
  ```

#### Mathematical Content

- Number significant equations
- Use `\mathbf{}` for vectors and matrices
- Define variables and symbols in nomenclature
- Example:
  ```latex
  \begin{equation}
    \mathbf{x} = \begin{bmatrix} x_1 \\ x_2 \\ \vdots \\ x_n \end{bmatrix}
    \label{eq:vector}
  \end{equation}
  ```

#### Code Listings

- Use consistent indentation
- Include language specification
- Add captions for reference
- Example:
  ```latex
  \begin{lstlisting}[language=Java, caption=Euclidean Algorithm, label=lst:euclid]
  public int gcd(int a, int b) {
      while (b != 0) {
          int temp = b;
          b = a % b;
          a = temp;
      }
      return a;
  }
  \end{lstlisting}
  ```

### Writing Style

#### Structure

- Start chapters with overview paragraph
- End chapters with summary
- Use consistent heading levels
- Maintain logical flow between sections

#### Technical Writing

- Use the active voice whenever possible
- Keep sentences concise and clear
- Define technical terms at first use
- Use consistent terminology throughout

#### Citations

- Cite after relevant statement
- Group multiple citations: `\cite{ref1,ref2}`
- Integrate naturally in text:
  - As shown by \textcite{smith2020}...
  - This approach \parencite{jones2019}...
- Always ensure every citation key used in LaTeX source files exists in `mainbibliography.bib`, and the bibliography compiles without missing references.

### Document Sections

**Note:** Avoid redundancy between sections (e.g., do not repeat the same background in Abstract and Introduction).

- Check for spelling and grammar errors in all written content.

#### Abstract

- Clear problem statement
- Methodology summary
- Key results
- Main conclusions

#### Introduction

- Context and motivation
- Problem definition
- Research objectives
- Document structure

#### Literature Review

- Organize by themes
- Critical analysis
- Gap identification
- Synthesis of findings

#### Methodology

- Clear research approach
- Detailed procedures
- Justification of choices
- Validation methods

#### Results

- Present findings objectively
- Use appropriate visualizations
- Statistical significance
- Error analysis

#### Conclusion

- Summary of contributions
- Research implications
- Future work
- Limitations
