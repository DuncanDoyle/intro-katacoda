Now that we have defined our domain-model and configured it to be used and consumed by Planner, we can start writing our contraint rules.

In the configuration of our `@PlanningSolution`, we've specified that our score should be a `HardSoftScore` (note the Planner support a lot of different score types, for example `HardMediumSoftScore`, `BendableScore`, etc. For more information, please consult the [manual](https://docs.optaplanner.org/7.2.0.Final/optaplanner-docs/html_single/index.html#scoreType)). `HardSoftScore` implies that we support two scores, a *Hard* score and a *Soft* score

*Hard Score* represent constraints that **must not** be broken. An example of a hard-constraint in our Cloud Balancing demo is that the total cpu requirement of all processes assigned to a computer should not exceed the available cpu on that computer. If a hard-constraint is broken, the solution is *infeasible*.

*Soft Score* represent constraints that should not be broken if they can be avoided or where breaking the constraints should be minimized. An example of a soft-constraint in the Cloud Balancing demo is to minimize the costs of the computers require to run our processes.

Business Resource Planner/OptaPlanner provides 3 ways in which you can implement your constraint rules:

1. Easy Java: calculate the full score of each solution in every step. Easy to implement but extremely slow and not suitable for (most) production use-cases
2. Incremental Java: only calculate the score increments in every step. Very hard to implement but can be really fast (if implemented correctly). Hard tp manage and maintain.
3. Drools: incremental score calculation using the Drools engine. Every constriant is implemented as a score rule. High performant and easy to implement and maintain.

Given the above, we will use Drools to implement our rules. Let's first create a Drools global variable that will hold our planning score.
