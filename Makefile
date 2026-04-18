build:
	dune build

build_sdl:
	dune build @sdl

run_sdl:
	dune exec prog/game_sdl.exe

doc:
	asciidoctor-pdf rapport/main.adoc -o rapport-rooy-le--hir--maze.pdf

clean:
	rm rapport-rooy-le--hir--maze.pdf
	rm -rf _build

