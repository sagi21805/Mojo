from memory.unsafe import Pointer
from time import now
from python import Python


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
        print("[", end = "")
        for i in range(self.size-1):
            print(self.data.load(i), end = ", ")
        print(self.data.load(self.size-1), end = "]")

    fn __add__(self, arr: Array) raises -> Array:
        if self.size == arr.size:
            var new = Array(self.size)
            for i in range(self.size):
                new[i] = self[i] + arr[i]
        
            return Array(new)
        
        else:
            raise Error("arrays are not on the same length")

    fn __mul__(self, arr: Array) raises -> Array:
        if self.size == arr.size:
            var new = Array(self.size)
            for i in range(self.size):
                new[i] = self[i] * arr[i]
        
            return Array(new)
        
        else:
            raise Error("arrays are not on the same length")

    fn __add__(self, scalar: Int) raises -> Array:
        var new = Array(self.size)
        for i in range(self.size):
            new[i] = self[i] + scalar
    
        return Array(new)
        

    fn __mul__(self, scalar: Int) raises -> Array:
        var new = Array(self.size)
        for i in range(self.size):
            new[i] = self[i] * scalar
    
        return Array(new)
                
    
    
    
    
fn main() raises:
    var arr: Array = Array(1000000, 10)
    
    var arr2 = Array(1000000, 3)

    var arr3 = arr * arr2 
    var arr4 = (arr3 + 1) * 20
    print(arr4[arr4.size-1])

    # var o = Pointer[String]()
    # o = o.alloc(10)
        
