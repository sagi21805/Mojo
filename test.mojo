struct MyInt:
    var value: Int
    
    fn __init__(inout self, v: Int):
        self.value = v

    fn __copyinit__(inout self, other: MyInt):
        self.value = other.value
        
    # self and rhs are both immutable in __add__.
    fn __add__(self, rhs: MyInt) -> MyInt:
        return MyInt(self.value + rhs.value)
        
    # ... now this works:
    fn __iadd__(inout self, rhs: Int):
        self = self + rhs

fn main(): 
    var x: MyInt = 42
    x += 1
    print(x.value) # prints 43 as expected

# However...
    var y = x
# Uncomment to see the error:
    y += 1       # ERROR: Cannot mutate 'let' value