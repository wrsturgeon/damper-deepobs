import optimizers as opt

from deepobs import pytorch as pt


optimizer_name = "damper"  # "sgd"
problem_name = "quadratic_deep"


optimizer_class = opt.optimizers[optimizer_name]
all_hparams = opt.all_hyperparameters[optimizer_name]
set_hparams = opt.set_hyperparameters[optimizer_name]


runner = pt.runners.StandardRunner(optimizer_class, all_hparams)
runner.run(
    testproblem=problem_name,
    hyperparams=set_hparams,
    num_epochs=10,
)
