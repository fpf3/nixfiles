{pkgs} :
with pkgs; [
  (
    python3.withPackages (
      ps: with ps; [
        hglib
        ipympl
        ipython
        jupyter
        matplotlib
        numpy
        pandas
        scipy
        sympy
        wxpython
      ]
    )
  )
]
