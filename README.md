<!--
SPDX-FileNotice: 🅭🄍1.0 This file is dedicated to the public domain using the CC0 1.0 Universal Public Domain Dedication <https://creativecommons.org/publicdomain/zero/1.0/>.
SPDX-FileContributor: Jason Yundt <jason@jasonyundt.email> (2021–2022)

TODO: Change this link once I have a page on my site for Simple Brick Breaker.
-->
# [Simple Brick Breaker](https://jasonyundt.website/posts/simple-brick-breaker-pre-release.html)

## Running from source

### Prerequisites

- [Godot Engine] [v3.4.4]

### Import and run

1. Open Godot.
2. In Godot’s [Project Manager], click “Import”.
3. Navigate to the `project/` folder.
4. Select `project.godot`.
5. Click “Import & Edit”.
5. Click on the [playtest button] that looks like this: ▶

## Hints for contributors

- Every file should declare its own copying information. See the comment at the
top of `COPYING.md` for an example.
- Use tabs for indentation. The only exception to this rule is in YAML files
because [YAML requires spaces for
indentation.](https://yaml.org/spec/1.2.2/#61-indentation-spaces) In YAML
files, use 4 spaces for indentation.
- The .pxo files are [Pixelorama](https://orama-interactive.itch.io/pixelorama)
projects.
- Before adding images to the project,
	I convert them into lossless WebPs using cwebp to make them smaller:

		cwebp input.png -o lossless output.webp

	Cwebp is from [libwebp](https://developers.google.com/speed/webp/).


## pre-commit

You can use [pre-commit] to automatically check your contributions.

1. Open a terminal.
2. Make sure that [pre-commit] is installed.
	1. Run `pre-commit --version`
	2. If it gives you an error, follow [these instructions](https://pre-commit.com/#installation).
3. `cd` to the root of this repo.
4. Install [pre-commit] as a [Git hook]. To do so, run
	```bash
	pre-commit install
	```

At this point, whenever you run `git commit`, [pre-commit] will run a series of
tests for the files that you modified.

There’s a few [pre-commit] hook failures that I’m OK with:

- Some [Markdown](https://daringfireball.net/projects/markdown/) files fail one
of pre-commit’s hooks, but only because one line is too long. I’m OK with that
line being too long.

When I run into an error that I’m OK with, I [skip the failing hooks](https://pre-commit.com/#temporarily-disabling-hooks)
for that commit.

## Copying

See [COPYING.md](./COPYING.md).

[Godot Engine]: https://godotengine.org/
[Git hook]: https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks
[playtest button]: https://docs.godotengine.org/en/latest/community/contributing/docs_writing_guidelines.html#common-vocabulary-to-use-in-godot-s-documentation
[Project Manager]: https://docs.godotengine.org/en/stable/getting_started/introduction/first_look_at_the_editor.html#the-project-manager
[pre-commit]: https://pre-commit.com/
[v3.4.4]: https://godotengine.org/article/maintenance-release-godot-3-4-4
