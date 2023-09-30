# minty <span><a href="https://github.com/royfrancis/minty-quarto-website"><img src="minty.png" style="height:40px;vertical-align:middle;"></a></span> 

[![ci_badge](https://github.com/royfrancis/minty-quarto-website/workflows/deploy/badge.svg)](https://github.com/royfrancis/minty-quarto-website/actions?workflow=deploy)    [![lifecycle_badge](https://lifecycle.r-lib.org/articles/figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

A quarto website template for project reports. For a single page template, see [minty-quarto-webpage](https://github.com/royfrancis/minty-quarto-webpage).

![](preview-a.png)

![](preview-b.png)

For a demo site, see [here](https://royfrancis.github.io/minty-quarto-website).

## Usage

- Required quarto 1.2.2 or higher
- Run in the terminal

```
quarto use template royfrancis/minty-quarto-website
```

- Launch preview in the browser

```
quarto preview
```

- Render all html files into `docs` directory

```
quarto render
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

- Update `nbis` variables in **_quarto.yml**
- Add/modify reports in the `reports` directory as needed
- To selectively preview/render files:
  ```
  quarto preview reports/report.qmd
  quarto render reports/report.qmd
  ```
- To remove automatic list of files from the sidebar, remove `sidebar` from **_quarto.yml**.
  - You can optionally manually link reports in `index.qmd` like this:

  ```
  [Report](reports/report.qmd)
  ```
- If project is incomplete, set `completion.qmd` to not be rendered in **_quarto.yml**.

  ```
  render:
    - "*.qmd"
    - "!completion.qmd"
  ```

- Use `##` as the highest level heading. Do not use `#`.

## Acknowledgements

- Built using [Quarto](https://quarto.org/)
- Uses the [lightbox extension](https://github.com/quarto-ext/lightbox) for viewing images

---

2023 • Roy Francis
