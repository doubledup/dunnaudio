# dunnaudio
Dunnaudio website

## Dependencies

Install [bun](https://bun.sh), then install dependencies:
```sh
bun install
```

Install [imagemagick](https://imagemagick.org/).

## Local environment

Start the local server:
```
bun start
```

## Convert images

Place images in [`dist/raw-images/`](./dist/raw-images/). Run image conversion:
```
bun run convertImages
```
Output images will be in `dist/images/`.
