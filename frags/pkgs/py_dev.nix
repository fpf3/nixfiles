{pkgs} :
with pkgs; [
  (
    python3.withPackages (
      ps: with ps; [
        python-hglib
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
