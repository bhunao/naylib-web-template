202309211110

# Polymorph (ECS framework in nim)

- queryless

## Components

### create
`register` / `registerComponents`

**register component:** 
```nim
  type
    Player = object

    Pos = object
        x, y: float

    Vel = object
        speed, angle: float
```

**Register existing types:** 
```nim
type
    ExternalType = object

register defaultCompOpts:
    ExternalType
```


**subdata for components:** 
```nim
registerComponents defaultCompOpts:
    type
        SubData {.notComponent.} = object
        contents: seq[int]

    Data = object
        value: SubData
```

### components and instance types
```nim
import polymorph

registerComponents defaultCompOpts:
  type
    Foo = object
      text: string
      value: int
    Bar = object
      value: float

makeEcs()

# Create an entity with both components.
let
  entity = newEntityWith(
    Foo(text: "Hello!", value: 123),
    Bar(value: 12.34))

# Get instances for the components.
let
  foo = entity.fetch Foo
  bar = entity.fetch Bar

# Act on component fields through instances.
foo.text = "Hello"
foo.value = 17
assert foo.value == 17
bar.value = 5.5

# This is transformed into something like:
storageFoo[foo.int].text = "Hello"
storageFoo[foo.int].value = 17
assert storageFoo[foo.int].value == 17
storageBar[bar.int].value = 5.5
```

**`access` the underlying type directly:** 
```nim
let copyFoo = foo.access
# Translates to something like this:
let copyFoo = storageFoo[foo.int]
```

**update the whole component** 
```nim
foo.update Foo(text: "Hey there", value: 18)
```

**check if `fetch` returned a valid option** 
```nim
let foo = entity.fetch Foo
if not foo.valid:
  echo "Cannot find Foo on this entity"
```

### component utilities

| name                              | description                                   |
|---------------                    | ---------------                               |
| componentCount                    | retrieves the number of instances in use for a particular component type.    |
| typeName(typeId: componentTypeId) | add components to an entity.                  |

## Systems

### create
`defineSystem` / `makeSystem`

### system components

#### system components
```nim
registerComponents defaultCompOpts:
  type
    Comp1 = object
    Comp2 = object

makeSystem "mySystem", [Comp1, Comp2]:
    all:
        echo item.comp1
        echo item.comp2
```

#### component negation
```nim
registerComponents defaultCompOpts:
  type
    Comp1 = object
    Comp2 = object

makeSystem "mySystem", [Comp1, not Comp2]:
    all:
        echo item.comp1
```

#### no components
cannot use `all` or `stream` because it has no components to go through
```nim
makeSystem "mySystem",:
  echo "Hello from system ", sys.name
```

#### acessing components
```nim
makeSystem "mySystem", [Comp1]:
    all:
        echo "Comp1: ", item.comp1
```

or 

```nim
makeSystem "mySystem", [Comp1]:
    all:
        echo "Comp1: ", comp1
```

#### component alias
```nim
makeSystem "mySystem", [c1: Comp1]:
    all:
        echo "entity: ", entity
        echo "Comp1: ", c1
        echo entity.fetch(Comp2)
```

#### acessing other components
```nim
makeSystem "mySystem", [Comp1]:
    all:
        echo "entity: ", entity
        echo "Comp1: ", comp1
        echo entity.fetch(Comp2)
```

### system body

#### declare system and body
```nim
import polymorph

registerComponents defaultCompOpts:
  type
    Comp1 = object
    Comp2 = object


makeSystem "mySystem", [Comp1, Comp2]:
  echo "Hello from system ", sys.name

makeEcs()

commitSystems "runSystems"

runSystems()
```

#### Declare system body later with `makeSystemBody`
```nim
import polymorph

registerComponents defaultCompOpts:
  type
    Comp1 = object
    Comp2 = object

makeSystem "mySystem", [Comp1, Comp2]:

makeEcs()

makeSystem "mySystem", [Comp1, Comp2]:
  echo "Hello from system ", sys.name

commitSystems "runSystems"

runSystems()
```

#### to specify system compile options

```nim
import polymorph

registerComponents defaultCompOpts:
  type
    Comp1 = object
    Comp2 = object

defineSystem "mySystem", [Comp1, Comp2], defaultSysOpts
    echo "Hello from system ", sys.name

makeEcs()

commitSystems "runSystems"

runSystems()
```

### committing systems

once commited each system created a procured named after the system with the prefix `do`

```nim
defineSystem "mySystem":
    echo "Hello from system ", sys.name

commitSystems "runMySystems"

doMySystem() # proc that run the system individually
```

### system anatomy

#### system scope blocks

| name          | description                                       |
|---------------| ---------------                                   |
| init          | run when the system's initialised field is false. After execution, initialised is set to true. |
| start         | executed every time a non-disabled system begins running, before the check for sys.paused. |
| finish        | run after a system body has finished executing, regardless of sys.paused state. |

> The start block is in the same scope as the system body and the all, stream, and finish blocks, so variables and data defined in start can be used within these blocks.

#### work item blocks
- `all`: run for every entity in the system.

- `stream`: run for an arbitrary number of entities in the system:
    - `stream`: run for up to sys.streamRate entities in order. If sys.streamRate is zero, all entities are processed as if this were an all block.
    - `stream N`: run for up to N entities in order.
    - `stream multipass`: run for sys.streamRate entities, reprocessing entities in order if necessary.
    - `stream multipass N`: run for N entities, reprocessing entities in order if necessary.
    - `stream stochastic`: selects sys.streamRate entities, may select entities multiple times.
    - `stream stochastic N`: selects N entities, may select entities multiple times.

**example:** 
```nim
import polymorph, random

registerComponents defaultCompOpts:
  type DemoBlocks = object

makeSystem "allTheBlocks", [DemoBlocks]:
  init:
    echo "Init: first run for ", sys.name
    randomize()

  start:
    echo "Start: system entities: ", sys.count
  
  echo "System running..."

  template entId: string = "entity " & $item.entity.entityId.int
  let srStr = "(rate: " & $sys.streamRate & ")"

  all:
    echo "  All: ", entId

  stream:
    echo "  Stream: ", srStr," ", entId

  let itemCount = 3
  stream itemCount:
    echo "  Stream up to ", itemCount, ": ", entId

  stream multipass 4:
    echo "  Stream multipass 4: ", entId

  stream stochastic 2:
    echo "  Stream stochastic 2: ", entId

  stream stochastic:
    echo "  Stream stochastic ", srStr, ": ", entId

  echo "System completed."

  start:
    sys.streamRate = 1
    echo "Start: set stream rate to ", sys.streamRate

  finish:
    echo "Finish: finished execution for ", sys.name
  
makeEcs()
commitSystems "run"
for i in 0 ..< 3:
  discard newEntityWith(DemoBlocks())
run()
```

### accessing items
`item` template to acess the current row entity's components

```nim
makeSystem "mySystem", [Comp1]:
    all:
        echo "entity: ", item.entity
        echo "entity: ", entity
        asset entity == item.entity
```




## Generating the ECS

Generate the code with `makeEcs` / `makeEcsCommit`

### After creating the ECS

#### Macros:

| name                      | description                                   |
|---------------            | ---------------                               |
| newEntityWith             | create an entity with a set of components.    |
| add/addComponents         | add components to an entity.                  |
| remove/removeComponents   | remove components from an entity.             |


#### Procs:

| name                  | description                                   |
|---------------        | ---------------                               |
| newEntity             | create an entity.                             |
| fetch/fetchComponent  | returns a component instance from an entity.  |
| delete                | delete the entity.                            |
| construct             | build an entity from a list of components.    |
| clone                 | copy an entity.                               |

     
#### Templates:

| name          | description                                       |
|---------------| ---------------                                   |
| caseComponent | a case statement for run time component type ids. |
| caseSystem    | a case statement for run time system ids.         |

##### Templates available withing `caseComponent` block

| name          | description                                       |
|---------------| ---------------                                   |
| componentId           | the ComponentTypeId being matched.        |
| componentName         | the string of the component name.         |
| componentType         | the type of the component.                |
| componentRefType      | the ref container type of the component.  |
| componentDel          | the delete procedure for manually deleting a component slot. |
| componentAlive        | the alive proc for this component.        |
| componentGenerations  | the storage list for this component's generation info. |
| componentInstanceType | the instance type for this component.     |
| componentData         | the storage list for this component.      |
| isOwned               | returns true when the component is owned by a system, or false otherwise. |
| owningSystemIndex     | the SystemIndex of the owner system, or InvalidSystemIndex if the component is not owned. |
| owningSystem          | this is only included for owned components, and references the owner system variable. |

**example of use:** 
```nim
import polymorph

registerComponents defaultCompOpts:
  type Comp1 = object

makeEcs()

let
  compList = cl(Comp1())

caseComponent compList[0].typeId:
  echo "Component type is ", componentName
```


#### Debugging:

| name          | description                                       |
|---------------| ---------------                                   |
| $             | operators for entities, component instances, and other supporting types. |

