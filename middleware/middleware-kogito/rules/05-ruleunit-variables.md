In the previous step you've implemented the rules of our application. We will now add a new variable to our unit and rules to control the age when someone is considered and adult.

## RuleUnit variables

Apart from using `DataSources` in our rule units to insert, update and delete facts, we can also define variables in our unit that can be used in our rules. In this use-case we will add an `adultAge` variable to our unit, which allows us to send the age at which a person is considered an adult in our request, and using that age in our rules.

## PersonUnit DRL

First, we add a new `adultAge` variable to our `PersonUnit` class:

<pre class="file" data-filename="./service-task/src/main/java/org/acme/PersonUnit.java" data-target="insert" data-marker="//Add adultAge variable here">
  private int adultAge
</pre>

We also add the _getters and setters_:

<pre class="file" data-filename="./service-task/src/main/java/org/acme/PersonUnit.java" data-target="insert" data-marker="//Add adultAge Getters and Setters here">
  public int getAdultAge() {
      return adultAge;
  }

  public void setAdultAge(int adultAge) {
      this.adultAge = adultAge;
  }
</pre>

With our variable implemented, we can now use this variable in our rules:

<pre class="file" data-filename="./service-task/src/main/resources/org/acme/PersonUnit.drl" data-target="insert" data-marker="$p: /persons[age >= 18];">
  $p: /persons[age >= adultAge];
</pre>

We've now added the functionality we want. Because we are still running our Kogito application in Quarkus dev-mode, we can simply hit our endpoint again with a new request, containing our `adultAge` variable:

`curl -X POST "http://localhost:8080/adult" -H "accept: application/json" -H "Content-Type: application/json" -d "{\"adultAge\": 21, \"persons\":[{\"age\":18,\"name\":\"Jason\"}]}"`{{execute}}

This will give you the following result:

```console
[{"name":"Jason","age":18,"adult":false}]
```

Notice that, because we have defined the `adultAge` to be 21, Jason is no longer considered an adult.

## OpenAPI Specification

A Kogito Quarkus application running in Quarkus dev-mode automatically exposes an OpenAPI specification of its RESTful resources through a Swagger-UI. You can open this Swagger [using this link](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/swagger-ui).

Open the **POST /adult** RESTful endpoint. Note that a fully typed API is generated for you, based on your business assets like your rule units and rules.

## Congratulations!

You have added a variable to your rule unit and used it in your rules. You've also experienced the power of live/hot reload of Kogito, providing extremely fast roundtrip times.