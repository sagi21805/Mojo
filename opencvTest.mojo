from memory import memcpy
from time import now
from math import clamp
from python import Python

fn numpy_data_pointer(numpy_array: PythonObject) raises -> DTypePointer[DType.uint32]:
    return DTypePointer[DType.uint32](
                __mlir_op.`pop.index_to_pointer`[
                    _type=__mlir_type.`!kgen.pointer<scalar<ui32>>`
                ](
                    SIMD[DType.index,1](numpy_array.__array_interface__['data'][0].__index__()).value
                )
            )

fn box_blur_mojo[diameter: Int](image: PythonObject) raises:
    # Get number of elements that fit into your hardwares SIMD register
    alias simd_width = simdwidthof[DType.uint32]()
    # The amount of pixels that will be averaged in box around the target pixel
    alias pixels = diameter ** 2
    alias radius = diameter // 2
    # Use the function we defined earlier to point to the numpy arrays raw data
    var p = numpy_data_pointer(image)
    # Get the numpy dimensions from the Python iterpreter and convert them to Mojo ints
    var height = image.shape[0].__index__()
    var width = image.shape[1].__index__()
    var el = width * height
    # Because we don't want blurred pixels influencing the outcome of the next pixel, we allocate a new array
    var tmp = DTypePointer[DType.uint32].alloc(el)

    for y in range(0, height):
        # Step over the amount of elements we'll operate on at the same time with SIMD
        for x in range(0, width, simd_width):
            var sum_r = SIMD[DType.uint32, simd_width]()
            var sum_g = SIMD[DType.uint32, simd_width]()
            var sum_b = SIMD[DType.uint32, simd_width]()

            # Loop through a box around the pixel
            for ky in range(-radius, radius):
                for kx in range(-radius, radius):
                    # Make sure to not go out of bounds
                    var iy = clamp(Int64(y) + ky, 0, height-1)
                    var ix = clamp(Int64(x) + kx, 0, width-1)
                    # Grab the amount of 32bit RGBA pixels that can fit into your hardwares SIMD register
                    var rgb = p.load[width=simd_width](iy.to_int() * width + ix.to_int())
                    # and seperate out the RGB components using bit shifts and masking, adding the values to the sums
                    sum_r += rgb & SIMD[DType.uint32, simd_width](255)
                    sum_g += rgb >> 8 & SIMD[DType.uint32, simd_width](255)
                    sum_b += rgb >> 16 & SIMD[DType.uint32, simd_width](255)

            # Combine 8bit color channels back into 32bit pixel (last channel is alpha 255 for no transparency)
            # And divide by total pixels in the box to get the average colors
            var combined = (sum_r / pixels) | (sum_g / pixels << 8) | (sum_b / pixels << 16) |  (255 << 24)
            # Store all the pixels at once (16 on a 512bit SIMD register)
            tmp.store(y * width + x, combined)
    # Copy the data from the temporay image to the original numpy array
    memcpy(p, tmp, el)
    tmp.free()


fn main() raises:
    Python.add_to_path("./")
    var py = Python.import_module("utils")
    var image = py.open_img("fire.jpeg")
    box_blur_mojo[8](image)
    py.imshow("name", image)