{pkgs} :
with pkgs; [
  (
    python3.withPackages (
      ps: with ps; with python3Packages; [
        hglib
        ipympl
        ipython
        jupyter
        matplotlib
        numpy
        pandas
        scipy
        sympy
      ]
    )
  )
]
