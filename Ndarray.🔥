from Array import Array
from time import now
from memory.unsafe import Pointer


struct Ndarray:
    var dims: Array
    var ndim: Int
    var data: Pointer[Array]
    var size: Int

    fn __init__(inout self, dims: Array) raises:
        self.dims = Array(dims)
        self.ndim = dims.size
        
        for dim in range(self.ndim):
            self.size += dims[dim]

        

    



fn main() raises:
    let arr = Array(2, 4)
    arr[0] = 640
    arr[1] = 480
    let Ndarray = Ndarray(arr)
    Ndarray.dims.print()

    let t = now()
    let arr2: Array = Array(100000, 9)
    var x: Int = 0
    for i in range(arr2.size):
        x += i * i
    print(x)
    print_no_newline("time: ")
    print(now() - t)