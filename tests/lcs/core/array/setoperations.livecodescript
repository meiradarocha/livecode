script "CoreArraySetOp"
/*
Copyright (C) 2015 LiveCode Ltd.

This file is part of LiveCode.

LiveCode is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License v3 as published by the Free
Software Foundation.

LiveCode is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
for more details.

You should have received a copy of the GNU General Public License
along with LiveCode.  If not see <http://www.gnu.org/licenses/>.  */

/*
Semantics of array union:

function ArrayUnion(pLeft, pRight, pRecursive)
	repeat for each key tKey in pRight
		if tKey is not among the keys of pLeft then
			put pRight[tKey] into pLeft[tKey]
		else if pRecursive then
			put ArrayUnion(pLeft[tKey], pRight[tKey], true) into pLeft[tKey]
		end if
	end repeat
	
	return pLeft
end ArrayUnion

*/
on TestArrayUnion
	
	local tString1	
	put "a" into tString1
	union tString1 with "b"
	TestAssert "union: left non-array, right non-array", tString1 is "a"
	
	local tString2, tFixedArray
	put "a" into tString2
	put "b" into tFixedArray[1]
	union tString2 with tFixedArray
	TestAssert "union: left non-array, right array", tString2[1] is "b"
	
	local tArray1
	put "a" into tArray1[1]
	union tArray1 with "b"
	TestAssert "union: left array, right non-array", tArray1[1] is "a"
	
	local tArray2
	put "a" into tArray2[1]
	union tArray2 with tFixedArray
	TestAssert "union: left array, right array, same key", tArray2[1] is "a"
	
	local tArray3
	put "c" into tArray3[2]
	union tArray3 with tFixedArray
	TestAssert "union: left array, right array, existing key", tArray3[2] is "c"
	TestAssert "union: left array, right array, additional key", tArray3[1] is "b"
end TestArrayUnion

on TestNestedArrayNonRecursiveUnion

	local tLeftArray2, tRightArray2
	put "a" into tLeftArray2[1]
	put "b" into tRightArray2[1][1]
		
	union tLeftArray2 with tRightArray2
	TestAssert "non-recursive union: left value non-array, right value array", tLeftArray2[1] is "a"
	
	local tLeftArray4, tRightArray4
	put "a" into tLeftArray4[1][1]
	put "b" into tRightArray4[1][2]
	union tLeftArray4 with tRightArray4
	TestAssert "non-recursive union: left value array, right value array, additional key", tLeftArray4[1][2] is empty
	
end TestNestedArrayNonRecursiveUnion

on TestNestedArrayRecursiveUnion

	local tLeftArray1, tRightArray1
	put "a" into tLeftArray1[1]
	put "b" into tRightArray1[1]
	union tLeftArray1 with tRightArray1 recursively
	TestAssert "recursive union: left value non-array, right value non-array", tLeftArray1[1] is "a"

	local tLeftArray2, tRightArray2
	put "a" into tLeftArray2[1]
	put "b" into tRightArray2[1][1]
		
	union tLeftArray2 with tRightArray2 recursively
	TestAssert "recursive union: left value non-array, right value array", tLeftArray2[1][1] is "b"
	
	local tLeftArray3, tRightArray3
	put "a" into tLeftArray3[1][1]
	put "b" into tRightArray3[1]
	union tLeftArray3 with tRightArray3 recursively
	TestAssert "recursive union: left value array, right value non-array", tLeftArray3[1][1] is "a"
	
	local tLeftArray4, tRightArray4
	put "a" into tLeftArray4[1][1]
	put "b" into tRightArray4[1][2]
	union tLeftArray4 with tRightArray4 recursively
	TestAssert "recursive union: left value array, right value array, existing key", tLeftArray4[1][1] is "a"
	TestAssert "recursive union: left value array, right value array, additional key", tLeftArray4[1][2] is "b"
	
end TestNestedArrayRecursiveUnion

/*
Semantics of array intersect:

function ArrayIntersect(pLeft, pRight, pRecursive)
	repeat for each key tKey in pLeft
		if tKey is not among the keys of pRight then
			delete variable pLeft[tKey]
		else if pRecursive then
			put ArrayIntersect(pLeft[tKey], pRight[tKey], true) into pLeft[tKey]
		end if
	end repeat
	
	return pLeft
end ArrayIntersect
*/

on TestArrayIntersect

	local tString1	
	put "a" into tString1
	intersect tString1 with "b"
	TestAssert "intersect: left non-array, right non-array", tString1 is "a"
	
	local tString2, tFixedArray
	put "a" into tString2
	put "b" into tFixedArray[1]
	intersect tString2 with tFixedArray
	TestAssert "intersect: left non-array, right array", tString2 is "a"
	
	local tArray1
	put "a" into tArray1[1]
	intersect tArray1 with "b"
	TestAssert "intersect: left array, right non-array", tArray1 is empty
	
	local tArray2
	put "a" into tArray2[1]
	intersect tArray2 with tFixedArray
	TestAssert "intersect: left array, right array, same key", tArray2[1] is "a"
	
	local tLeftArray3, tRightArray3
	put "a" into tLeftArray3[1]
	put "b" into tLeftArray3[2]
	put "c" into tRightArray3[2]
	put "d" into tRightArray3[3]
	intersect tLeftArray3 with tRightArray3
	TestAssert "intersect: left array, right array, key present in left not right", tLeftArray3[1] is empty	
	TestAssert "intersect: left array, right array, key present in right not left", tLeftArray3[3] is empty
	TestAssert "intersect: left array, right array, key present in left and right", tLeftArray3[2] is "b"

end TestArrayIntersect

on TestNestedArrayNonRecursiveIntersect

	local tLeftArray2, tRightArray2
	put "a" into tLeftArray2[1]
	put "b" into tRightArray2[1][1]
		
	intersect tLeftArray2 with tRightArray2
	TestAssert "non-recursive intersect: left value non-array, right value array", tLeftArray2[1] is "a"
	
	local tLeftArray4, tRightArray4
	put "a" into tLeftArray4[1][1]
	put "b" into tRightArray4[1][2]
	intersect tLeftArray4 with tRightArray4
	TestAssert "non-recursive intersect: left value array, right value array, additional key", tLeftArray4[1][1] is "a"
	
end TestNestedArrayNonRecursiveIntersect

on TestNestedArrayRecursiveIntersect

	local tLeftArray1, tRightArray1
	put "a" into tLeftArray1[1]
	put "b" into tRightArray1[1]
	intersect tLeftArray1 with tRightArray1 recursively
	TestAssert "recursive intersect: left value non-array, right value non-array", tLeftArray1[1] is "a"

	local tLeftArray2, tRightArray2
	put "a" into tLeftArray2[1]
	put "b" into tRightArray2[1][1]
		
	intersect tLeftArray2 with tRightArray2 recursively
	TestAssert "recursive intersect: left value non-array, right value array", tLeftArray2[1] is "a"
	
	local tLeftArray3, tRightArray3
	put "a" into tLeftArray3[1][1]
	put "b" into tRightArray3[1]
	intersect tLeftArray3 with tRightArray3 recursively
	TestAssert "recursive intersect: left value array, right value non-array", tLeftArray3[1] is empty
	
	local tLeftArray4, tRightArray4
	put "a" into tLeftArray4[1][1]
	put "b" into tLeftArray4[1][2]
	put "c" into tRightArray4[1][2]
	put "d" into tRightArray4[1][3]
	intersect tLeftArray4 with tRightArray4 recursively
	TestAssert "recursive intersect: left value array, right value array, key present in left not right", tLeftArray4[1][1] is empty	
	TestAssert "recursive intersect: left value array, right value array, key present in right not left", tLeftArray4[1][3] is empty
	TestAssert "recursive intersect: left value array, right value array, key present in left and right", tLeftArray4[1][2] is "b"
	
end TestNestedArrayRecursiveIntersect
