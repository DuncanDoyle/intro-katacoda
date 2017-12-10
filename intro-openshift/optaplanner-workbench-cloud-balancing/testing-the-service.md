With our *Decision Server* deployed, we can now start planning our Cloud Balancing problems. As our *Decision Server* exposes a REST API, we can simply test our service using `cURL` (any other REST client can of course be used, but `cURL` is easy to use in this Katacoda environment).

We first need to determine the endpoint exposed by our application's *Route*.

`oc get route`{{copy}}

Once the DecisionServer with our project has been deployed, we first need to create a *Solver*. The *Solver* is the component on the *Decision Server* that is responsible for solving our problem (i.e. finding the optimal solution).

`curl -u brpAdmin:jbossbrp@01 -X PUT -H "Accept: application/xml" -H "Content-Type: application/xml" -H "X-KIE-ContentType: XSTREAM" -d '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><solver-instance><container-id>cloudBalance</container-id><solver-id>cloudBalanceSolver</solver-id><solver-config-file>optaplanner/cloud_balancing/CloudBalancingSolverConfig.solver.xml</solver-config-file></solver-instance>' http://cloud-balancing-cloud-balancing.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/kie-server/services/rest/server/containers/container-cloudbalancing-100/solvers/cloudBalancingSolver`{{copy}}

Because the inline JSON in the cUrl command is a bit hard to read, we have printed the formatted XML request below:

```
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<solver-instance>
    <container-id>cloudBalance</container-id>
    <solver-id>cloudBalanceSolver</solver-id>
    <solver-config-file>optaplanner/cloud_balancing/CloudBalancingSolverConfig.solver.xml</solver-config-file>
</solver-instance>
```

Now that we've configured a *Solver* one our *Decision Server*, we can send it a Cloud Balancing problem in the form of an unsolved `CloudBalancingSolution` instance. We can use the following cURL command to send a *Cloud Balancing Solution* request to the server:

`curl -u brpAdmin:jbossbrp@01 -X POST -H "Accept: application/xml" -H "Content-Type: application/xml" -H "X-KIE-ContentType: XSTREAM" -H "X-KIE-ClassType: optaplanner.cloud_balancing.CloudBalancingSolution" -d '<solver-instance><status>SOLVING</status><planning-problem class="optaplanner.cloud_balancing.CloudBalancingSolution"><processes><optaplanner.cloud__balancing.Process><id>1</id><requiredCpu>2</requiredCpu></optaplanner.cloud__balancing.Process><optaplanner.cloud__balancing.Process><id>2</id><requiredCpu>1</requiredCpu></optaplanner.cloud__balancing.Process><optaplanner.cloud__balancing.Process><id>3</id><requiredCpu>3</requiredCpu></optaplanner.cloud__balancing.Process><optaplanner.cloud__balancing.Process><id>4</id><requiredCpu>1</requiredCpu></optaplanner.cloud__balancing.Process></processes><computers><optaplanner.cloud__balancing.Computer><id>1</id><cpu>4</cpu><cost>300</cost></optaplanner.cloud__balancing.Computer><optaplanner.cloud__balancing.Computer><id>2</id><cpu>5</cpu><cost>500</cost></optaplanner.cloud__balancing.Computer><optaplanner.cloud__balancing.Computer><id>3</id><cpu>6</cpu><cost>700</cost></optaplanner.cloud__balancing.Computer></computers></planning-problem></solver-instance>' http://cloud-balancing-cloud-balancing.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/kie-server/services/rest/server/containers/container-cloudbalancing-100/solvers/cloudBalancingSolver`{{copy}}

Because the inline JSON in the cUrl command is a bit hard to read, we have printed the formatted XML request below:

```
<solver-instance>
	<status>SOLVING</status>
    <planning-problem class="optaplanner.cloud_balancing.CloudBalancingSolution">
  <processes>
    <optaplanner.cloud__balancing.Process>
      <id>1</id>
      <requiredCpu>2</requiredCpu>
    </optaplanner.cloud__balancing.Process>
    <optaplanner.cloud__balancing.Process>
      <id>2</id>
      <requiredCpu>1</requiredCpu>
    </optaplanner.cloud__balancing.Process>
    <optaplanner.cloud__balancing.Process>
      <id>3</id>
      <requiredCpu>3</requiredCpu>
    </optaplanner.cloud__balancing.Process>
    <optaplanner.cloud__balancing.Process>
      <id>4</id>
      <requiredCpu>1</requiredCpu>
    </optaplanner.cloud__balancing.Process>
  </processes>
  <computers>
    <optaplanner.cloud__balancing.Computer>
      <id>1</id>
      <cpu>4</cpu>
      <cost>300</cost>
    </optaplanner.cloud__balancing.Computer>
    <optaplanner.cloud__balancing.Computer>
      <id>2</id>
      <cpu>5</cpu>
      <cost>500</cost>
    </optaplanner.cloud__balancing.Computer>
    <optaplanner.cloud__balancing.Computer>
      <id>3</id>
      <cpu>6</cpu>
      <cost>700</cost>
    </optaplanner.cloud__balancing.Computer>
  </computers>
  </planning-problem>
</solver-instance>
```

This XML request is the *XStream* representation of our BRP/OptaPlanner `CloudBalancingSolution` in which we have defined 4 *Processes* to be assigned to 3 *Computers* in the most optimal way possible. The response will look like this:

```
<org.kie.server.api.model.ServiceResponse>
    <type>SUCCESS</type>
    <msg>Solver &apos;cloudBalancingSolver&apos; from container &apos;bf38d12180b058415faf1193ca487f03&apos; successfully updated.</msg>
    <result class="solver-instance">
        <container-id>bf38d12180b058415faf1193ca487f03</container-id>
        <solver-id>cloudBalancingSolver</solver-id>
        <solver-config-file>optaplanner/cloud_balancing/CloudBalancingSolverConfig.solver.xml</solver-config-file>
        <status>SOLVING</status>
    </result>
</org.kie.server.api.model.ServiceResponse>
```

Note that the reponse does not contain a solution yet. We need to give Business Resource Planner some time to calculate and evaluate the business-central planning solution. We've configured the *termination* of our solver to be 30 seconds, so  after 30 seconds, the solver will stop solving and we can retrieve the solution created by planner (note that you can retrieve the best solution while the solver is solving as well. Anytime the solver finds a new best solution, it makes that available to be retrieved via the RESTfule API).

Use the followig cURL command to retrieve the best solution:

`curl -u brpAdmin:jbossbrp@01 -X GET -H "Accept: application/xml" -H "Content-Type: application/xml" -H "X-KIE-ContentType: XSTREAM" http://cloud-balancing-cloud-balancing.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/kie-server/services/rest/server/containers/container-cloudbalancing-100/solvers/cloudBalancingSolver/bestsolution`{{copy}}

The response will look like this:

```
<org.kie.server.api.model.ServiceResponse>
  <type>SUCCESS</type>
  <msg>Best computed solution for &apos;cloudBalancingSolver&apos; successfully retrieved from container &apos;bf38d12180b058415faf1193ca487f03&apos;</msg>
  <result class="solver-instance">
    <container-id>bf38d12180b058415faf1193ca487f03</container-id>
    <solver-id>cloudBalancingSolver</solver-id>
    <solver-config-file>optaplanner/cloud_balancing/CloudBalancingSolverConfig.solver.xml</solver-config-file>
    <status>NOT_SOLVING</status>
    <score class="org.optaplanner.core.api.score.buildin.hardsoft.HardSoftScore">
      <hardScore>0</hardScore>
      <softScore>-800</softScore>
    </score>
    <best-solution class="optaplanner.cloud_balancing.CloudBalancingSolution">
      <score class="org.optaplanner.core.api.score.buildin.hardsoft.HardSoftScore" reference="../../score"/>
      <processes>
        <optaplanner.cloud__balancing.Process>
          <id>1</id>
          <computer>
            <id>1</id>
            <cpu>4</cpu>
            <cost>300</cost>
          </computer>
          <requiredCpu>2</requiredCpu>
        </optaplanner.cloud__balancing.Process>
        <optaplanner.cloud__balancing.Process>
          <id>2</id>
          <computer reference="../../optaplanner.cloud__balancing.Process/computer"/>
          <requiredCpu>1</requiredCpu>
        </optaplanner.cloud__balancing.Process>
        <optaplanner.cloud__balancing.Process>
          <id>3</id>
          <computer>
            <id>2</id>
            <cpu>5</cpu>
            <cost>500</cost>
          </computer>
          <requiredCpu>3</requiredCpu>
        </optaplanner.cloud__balancing.Process>
        <optaplanner.cloud__balancing.Process>
          <id>4</id>
          <computer reference="../../optaplanner.cloud__balancing.Process/computer"/>
          <requiredCpu>1</requiredCpu>
        </optaplanner.cloud__balancing.Process>
      </processes>
      <computers>
        <optaplanner.cloud__balancing.Computer reference="../../processes/optaplanner.cloud__balancing.Process/computer"/>
        <optaplanner.cloud__balancing.Computer reference="../../processes/optaplanner.cloud__balancing.Process[3]/computer"/>
        <optaplanner.cloud__balancing.Computer>
          <id>3</id>
          <cpu>6</cpu>
          <cost>700</cost>
        </optaplanner.cloud__balancing.Computer>
      </computers>
    </best-solution>
  </result>
</org.kie.server.api.model.ServiceResponse>
```

We can see that Processes 1, 2 and 4 have been assigned to Computer 1 and Processes 3 has been assigned to Computer 2. We can also see that we have a *hard-score* of 0, which means that our solution is feasible (i.e. the processes have been assigned in such a way that they don't overload the computers' CPU capacity). We also have a *soft-score* of -800. As we know, the *soft-score* is defined by the total costs of the comuters to which ate least 1 process has been assigned. In this example, computer 1 and 3 are being used, which results in a total cost of 300 + 500 = 800.

More examples of Business Resource Planner/OptaPlanner are available on the [OptaPlanner website](https://www.optaplanner.org).
