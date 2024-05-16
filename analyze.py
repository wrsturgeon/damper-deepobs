import optimizers as opt

from deepobs import analyzer
import os


optimizer_name = "damper"  # "sgd"
problem_name = "quadratic_deep"


results_dir = os.path.join(".", "results", problem_name, optimizer_name)


# get the overall best performance of the MomentumOptimizer on the quadratic_deep testproblem
performance_dic = analyzer.get_performance_dictionary(results_dir)
print(performance_dic)

# plot the training curve for the best performance
analyzer.plot_optimizer_performance(results_dir)
