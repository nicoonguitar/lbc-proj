# ServiceLocator

A simple implementation of a Service Locator. It allows to register factory and singleton instances. The Assembly type allows to each module to register its own types, to avoid defining implementation types as public.

I decided to use it in order to respect the Dependency Inversion rule and have something similar to DI without having to implement a DAG (directed acyclic graph) myself (takes too much time and I think it's out of scope). Here an alternative could be to use the [SwiftGraph](https://github.com/davecom/SwiftGraph) open source project to instanciate their implementation of a DAG to correctly topologically sort the graph and check for dependencies issues (missing registrations, cyclic dependencies, etc), but the test states that I cannot use third party dependencies. 
