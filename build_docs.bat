@echo off
REM Full LaTeX + BibTeX build with output in compile/
REM Usage: build_docs.bat [filename]
REM   filename: .tex file to build (e.g. main or main.tex). Default: main.tex

if "%~1"=="" (
  set "TEX=main.tex"
  set "JOB=main"
) else (
  if "%~x1"==".tex" (
    set "TEX=%~1"
    set "JOB=%~n1"
  ) else (
    set "TEX=%~1.tex"
    set "JOB=%~1"
  )
)

REM So pdflatex finds .bbl and .aux in compile/ when using -output-directory=compile
set TEXINPUTS=compile\;%TEXINPUTS%

echo [1/4] pdflatex (first pass)...
pdflatex -interaction=batchmode -quiet -output-directory=compile %TEX% >nul 2>&1
if errorlevel 1 exit /b 1

echo [2/4] bibtex (builds bibliography from .aux and .bib)...
cd compile
set BIBINPUTS=..;
set BSTINPUTS=..;
bibtex %JOB% >nul 2>&1
cd ..
if errorlevel 1 exit /b 1

echo [3/4] pdflatex (second pass - includes .bbl)...
pdflatex -interaction=batchmode -quiet -output-directory=compile %TEX% >nul 2>&1
if errorlevel 1 exit /b 1

echo [4/4] pdflatex (third pass - resolves all refs)...
pdflatex -interaction=batchmode -quiet -output-directory=compile %TEX% >nul 2>&1

echo Done. PDF: compile\%JOB%.pdf
exit /b 0

