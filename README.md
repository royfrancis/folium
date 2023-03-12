# minty-quarto-website

A quarto website template for project reports.

![](preview-a.png)

![](preview-b.png)

## Usage

- Required quarto 1.2.335 or higher
- Run in the terminal

```
quarto use template royfrancis/minty-quarto-website
```

- Launch preview

```
quarto preview
```

## Tips

- Template directory structure

```
.
├── assets
├── completion.qmd
├── _extensions
├── index.qmd
├── _quarto.yml
└── reports
    └── report.qmd

```

- Add/modify reports in the `reports` directory as needed
- To remove automatic list of files from the sidebar, remove `sidebar` from `_quarto.yml`.
  - You can optionally manually link reports in `index.qmd` like this:

  ```
  [Report](reports/report.qmd)
  ```
- Include `completion.qmd` on completion of the project, else remove it.

## Acknowledgements

- Built using [Quarto](https://quarto.org/)
- Uses the [lightbox extension](https://github.com/quarto-ext/lightbox) for viewing images

---
2023 • Roy Francis