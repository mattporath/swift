// RUN: %target-run-simple-swift | FileCheck %s

// Create a new array
var a = new Int[10]
for i in 0..10 { a[i] = i }
println(a)
// CHECK: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

// Create a new unsigned array
var u = new UInt64[10]
for i in 0..10 { u[i] = UInt64(i) }
println(u)
// CHECK: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

// Copy a slice to another slice
a[1..3] = a[5..7]
println(a)
// CHECK: [0, 5, 6, 3, 4, 5, 6, 7, 8, 9]

// Copy a slice to another slice with overlap
a[4..8] = a[6..10]
println(a)
// CHECK: [0, 5, 6, 3, 6, 7, 8, 9, 8, 9]

// Create another array and copy in a slice
var b = new Int[10]
b[3...6] = a[5..9]
println(b)
// CHECK: [0, 0, 0, 7, 8, 9, 8, 0, 0, 0]

// Create a 2D array
var aa = new Int[10][]
for i in 0..10 {
  var a = new Int[10]
  for j in 0..10 {
    a[j] = i*10 + j
  }
  aa[i] = a
}
println(aa)
// CHECK: {{\[}}[0, 1, 2, 3, 4, 5, 6, 7, 8, 9], [10, 11, 12, 13, 14, 15, 16, 17, 18, 19], [20, 21, 22, 23, 24, 25, 26, 27, 28, 29], [30, 31, 32, 33, 34, 35, 36, 37, 38, 39], [40, 41, 42, 43, 44, 45, 46, 47, 48, 49], [50, 51, 52, 53, 54, 55, 56, 57, 58, 59], [60, 61, 62, 63, 64, 65, 66, 67, 68, 69], [70, 71, 72, 73, 74, 75, 76, 77, 78, 79], [80, 81, 82, 83, 84, 85, 86, 87, 88, 89], [90, 91, 92, 93, 94, 95, 96, 97, 98, 99]]

// Copy slices in a 2D array
aa[1..3] = aa[2..4]
println(aa)
// CHECK: {{\[}}[0, 1, 2, 3, 4, 5, 6, 7, 8, 9], [20, 21, 22, 23, 24, 25, 26, 27, 28, 29], [30, 31, 32, 33, 34, 35, 36, 37, 38, 39], [30, 31, 32, 33, 34, 35, 36, 37, 38, 39], [40, 41, 42, 43, 44, 45, 46, 47, 48, 49], [50, 51, 52, 53, 54, 55, 56, 57, 58, 59], [60, 61, 62, 63, 64, 65, 66, 67, 68, 69], [70, 71, 72, 73, 74, 75, 76, 77, 78, 79], [80, 81, 82, 83, 84, 85, 86, 87, 88, 89], [90, 91, 92, 93, 94, 95, 96, 97, 98, 99]]


// Verify that array literals don't leak. <rdar://problem/16536439>
class Canary {
  deinit { println("dead") }
}

println()

// CHECK: dead
// CHECK: dead
// CHECK: dead
{ [Canary(), Canary(), Canary()] }()

// Create an array of (String, Bool) pairs. <rdar://problem/16916422>
do {
  let x: (String, Bool)[] = [("foo", true)]
  println(x[0].0) // CHECK: foo
  println(x[0].1) // CHECK: true
} while false
println("still alive") // CHECK: still alive

// Construct some arrays and compare by equality.
let arr1 = [1, 2, 3, 4]
let arr2 = [1, 2, 3, 4]
let arr3 = [1, 2]
let arr4 = [5, 6]

let slice1_1_2 = arr1[1...2]
let slice2_1_2 = arr2[1...2]
let slice1_2_3 = arr1[2..3]
let slice2_2_3 = arr2[2..3]

let contig_arr1: NativeArray<Int> = [1, 2, 3, 4]
let contig_arr2: NativeArray<Int> = [1, 2, 3, 4]
let contig_arr3: NativeArray<Int> = [1, 2]
let contig_arr4: NativeArray<Int> = [5, 6]

// CHECK: arr1 == arr1: true
// CHECK-NEXT: arr1 == arr2: true
// CHECK-NEXT: arr1 != arr2: false
// CHECK-NEXT: arr2 == arr3: false
// CHECK-NEXT: arr2 != arr3: true
// CHECK-NEXT: arr1 != arr4: true
// CHECK-NEXT: arr1 == arr4: false
// CHECK-NEXT: slice1_1_2 == slice1_1_2: true
// CHECK-NEXT: slice1_1_2 == slice2_1_2: true
// CHECK-NEXT: slice1_1_2 != slice1_1_2: false
// CHECK-NEXT: slice1_2_3 == slice2_2_3: true
// CHECK-NEXT: contig_arr1 == contig_arr1: true
// CHECK-NEXT: contig_arr1 == contig_arr2: true
// CHECK-NEXT: contig_arr1 != contig_arr2: false
// CHECK-NEXT: contig_arr2 == contig_arr3: false
// CHECK-NEXT: contig_arr2 != contig_arr3: true
// CHECK-NEXT: contig_arr1 != contig_arr4: true
// CHECK-NEXT: contig_arr1 == contig_arr4: false
println("arr1 == arr1: \(arr1 == arr1)")
println("arr1 == arr2: \(arr1 == arr2)")
println("arr1 != arr2: \(arr1 != arr2)")
println("arr2 == arr3: \(arr2 == arr3)")
println("arr2 != arr3: \(arr2 != arr3)")
println("arr1 != arr4: \(arr1 != arr4)")
println("arr1 == arr4: \(arr1 == arr4)")
println("slice1_1_2 == slice1_1_2: \(slice1_1_2 == slice1_1_2)")
println("slice1_1_2 == slice2_1_2: \(slice1_1_2 == slice2_1_2)")
println("slice1_1_2 != slice1_1_2: \(slice1_1_2 != slice1_1_2)")
println("slice1_2_3 == slice2_2_3: \(slice1_2_3 == slice2_2_3)")
println("contig_arr1 == contig_arr1: \(contig_arr1 == contig_arr1)")
println("contig_arr1 == contig_arr2: \(contig_arr1 == contig_arr2)")
println("contig_arr1 != contig_arr2: \(contig_arr1 != contig_arr2)")
println("contig_arr2 == contig_arr3: \(contig_arr2 == contig_arr3)")
println("contig_arr2 != contig_arr3: \(contig_arr2 != contig_arr3)")
println("contig_arr1 != contig_arr4: \(contig_arr1 != contig_arr4)")
println("contig_arr1 == contig_arr4: \(contig_arr1 == contig_arr4)")
>>>>>>> Add basic '==' for Array, NativeArray, and Slice.
