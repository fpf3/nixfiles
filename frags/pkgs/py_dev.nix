{pkgs} :
with pkgs; [
  (
    python3.withPackages (
      ps: with ps; [
        hglib
        ipympl
        ipywidgets
        ipython
        jupyter
        jupyterlab
        matplotlib
        numpy
        pandas
        scipy
        statsmodels
        sympy
        wxpython
      ]
    )
  )
]
