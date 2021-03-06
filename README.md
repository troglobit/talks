
Hi!

If you are building on Debian, Ubuntu, or Linux Mint, you may have to
install a few packages to get fonts:

    # sudo apt install fonts-firacode texlive-fonts-extra texlive-latex-extra

Then create a file in /etc/fonts/conf.d/ to make the fonts work well
with the amazing Metropolis PDF theme:

    $ sudo vim /etc/fonts/conf.d/vim 09-texlive-fonts.conf
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <dir>/usr/share/texlive/texmf-dist/fonts/opentype</dir>
      <dir>/usr/share/texlive/texmf-dist/fonts/truetype</dir>
      <dir>/usr/share/texlive/texmf-dist/fonts/type1</dir>
    </fontconfig>
    <ESC>:wq
    $ sudo fc-cache -fsv

To convert svg files for inclusion in pdfs, you need:

    # sudo apt install librsvg2-bin

Some links to useful stuff:

  - <https://www.tug.org/texlive//devsrc/Master/texmf-dist/doc/latex/beamertheme-metropolis/metropolistheme.pdf>
  - <https://github.com/matze/mtheme>
  - <https://pandoc.org/MANUAL.html>

Have fun!  
 /Joachim
