import damper_pytorch as damper
from torch import optim


optimizers = {
    "sgd": optim.SGD,
    "damper": damper.Damper,
}
all_hyperparameters = {
    "sgd": {
        "lr": {"type": float},
        "momentum": {"type": float, "default": 0.99},
        "nesterov": {"type": bool, "default": False},
    },
    "damper": damper.hyperparameters,
}
set_hyperparameters = {
    "sgd": {"lr": 1e-2},
    "damper": {},
}
