from memory.unsafe import Pointer
from time import now

struct Array:
    var data: Pointer[Int]
    var size: Int
    # creates empty array 
    fn __init__(inout self, size: Int):
        """
        Initialize array of zeros for a given size.
        """
        self.size = size
        self.data = Pointer[Int].alloc(self.size)
    
        for i in range(self.size):
            self.data.store(i, 0)
    
    fn __init__(inout self, size: Int, val: Int):
        self.size = size
        self.data = Pointer[Int].alloc(self.size)
    
        for i in range(self.size):
            self.data.store(i, val)

    fn __init__(inout self, arr: Array) raises:
        self.size = arr.size
        self.data = Pointer[Int].alloc(arr.size)
        for i in range(arr.size):
            self.data.store(i, arr[i])
    
    fn __del__(owned self):
        self.data.free()

    fn __getitem__(self, i: Int) raises -> Int:
        if i >= self.size:
            raise Error("out of bounds")
        else:
            return self.data.load(i)
    
    fn __setitem__(self, i: Int, val: Int) raises:
        if i >= self.size:
            raise Error("out of bounds")
        else:
            self.data.store(i, val)

    fn print(self):
        print_no_newline("[")
        for i in range(self.size):
            if i > 0:
                print_no_newline(", ")
            print_no_newline(self.data.load(i))
        print("]")

    fn __add__(self, arr: Array) raises -> Array:
        if self.size == arr.size:
            let new = Array(self.size)
            for i in range(self.size):
                new[i] = self[i] + arr[i]
        
            return Array(new)
        
        else:
            raise Error("arrays are not on the same length")

    fn __mul__(self, arr: Array) raises -> Array:
        if self.size == arr.size:
            let new = Array(self.size)
            for i in range(self.size):
                new[i] = self[i] * arr[i]
        
            return Array(new)
        
        else:
            raise Error("arrays are not on the same length")

    fn __add__(self, scalar: Int) raises -> Array:
        let new = Array(self.size)
        for i in range(self.size):
            new[i] = self[i] + scalar
    
        return Array(new)
        

    fn __mul__(self, scalar: Int) raises -> Array:
        let new = Array(self.size)
        for i in range(self.size):
            new[i] = self[i] * scalar
    
        return Array(new)
                
    
    
    
    
fn main() raises:
    let arr: Array = Array(14, 32)
    
    let arr2 = Array(14, 100)

    let arr3 = arr * arr2 
    let arr4 = (arr3 + 1) * 20
    arr4.print()

    # var o = Pointer[String]()
    # o = o.alloc(10)
        
