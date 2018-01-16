In this scenario you've learned how to build a JBoss Business Resource Planner service on OpenShift.

We started by defining our repository and project in the JBoss BRMS web-based workbench *Business Central*. Next, we created our fist domain-model and constraint rules representing our *Planning Entities*, *Planning Variables*, *Planning Solution* and hard- and soft constraint rules.

We made our project available to our OpenShift S2I build process by pushing our project to GitHub. After configuring OpenShift with the correct *ImageStreams* and *Templates* we were able to create our project and JBoss BRP Solver service.

Finally we tested our rules using Postman and cURL.

JBoss Business Resource Planner/OptaPlanner supports many more use-cases and scenarios. Please consult the various online resources ([manuals](https://docs.optaplanner.org/7.2.0.Final/optaplanner-docs/html_single), [blogs](https://www.optaplanner.org/blogs), [examples](https://www.optaplanner.org/examples), [forums](https://www.optaplanner.org/forums), etc.) to continue your JBoss Business Resource Planner/OptaPlanner journey.
