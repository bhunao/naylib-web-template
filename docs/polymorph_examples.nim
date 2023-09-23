import polymorph

# Design stage.
register defaultCompOpts:
  type MyComponent = object
makeSystem "mySystem", [MyComponent]: discard

# Seal the design and generate the ECS and system code.
makeEcsCommit "runSystems"

# ECS can now be used.
let e = newEntityWith(MyComponent())
runSystems()
