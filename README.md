# dunnaudio

Dunnaudio website

## Dependencies

Install [bun](https://bun.sh), then install dependencies:
```sh
bun install
```

Install [imagemagick](https://imagemagick.org/).

## Convert images

Place images in [`dist/raw-images/`](./dist/raw-images/). Run image conversion:
```
bun run convertImages
```
Output images will be in [`dist/images/`][./dist/images/]. This will fail with exit code 1 if there are no images in
`dist/raw-images/`.

## Local environment

Start the local server:
```
bun start
```
Note: this fails when run on a clean repo because something elm-live does passes undefined for a "path" argument. Yay,
null errors!

<!--
TODO: switch to elm-pages
TODO: add responsive layout for mobile
TODO: resize & convert images to optimize loading time & quality

TODO: add responsive layout for tablet
TODO: add scrolling effect to carousel
TODO: add scrolling effect to testimonials
TODO: crop images slightly
-->

<!--
SEO tips (https://www.youtube.com/watch?v=IkmPjeNKkBQ):
- Target low-competition, long-tail keywords
- Create content that satisfies search intent
- Optimize content for on-page SEO
- Optimize content for user experience
- Build backlinks
Next: https://www.youtube.com/watch?v=xsVTqzratPs
-->
