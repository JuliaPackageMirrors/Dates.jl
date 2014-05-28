# Date internal algorithms
@test Dates.totaldays(0,2,28) == -307
@test Dates.totaldays(0,2,29) == -306
@test Dates.totaldays(0,3,1) == -305
@test Dates.totaldays(0,12,31) == 0
# Rata Die Days # start from 0001-01-01
@test Dates.totaldays(1,1,1) == 1
@test Dates.totaldays(1,1,2) == 2
@test Dates.totaldays(2013,1,1) == 734869

# Create "test" check manually
test = Dates.DateTime(Dates.UTM(63492681600000))
# Test DateTime construction by parts
@test Dates.DateTime(2013) == test
@test Dates.DateTime(2013,1) == test
@test Dates.DateTime(2013,1,1) == test
@test Dates.DateTime(2013,1,1,0) == test
@test Dates.DateTime(2013,1,1,0,0) == test
@test Dates.DateTime(2013,1,1,0,0,0) == test
@test Dates.DateTime(2013,1,1,0,0,0,0) == test
test = Dates.Date(Dates.UTD(734869))
# Test Date construction by parts
@test Dates.Date(2013) == test
@test Dates.Date(2013,1) == test
@test Dates.Date(2013,1,1) == test

# Test various input types for Date/DateTime
test = Date(1,1,1)
@test Date(int8(1),int8(1),int8(1)) == test
@test Date(uint8(1),uint8(1),uint8(1)) == test
@test Date(int16(1),int16(1),int16(1)) == test
@test Date(uint8(1),uint8(1),uint8(1)) == test
@test Date(int32(1),int32(1),int32(1)) == test
@test Date(uint32(1),uint32(1),uint32(1)) == test
@test Date(int64(1),int64(1),int64(1)) == test
@test Date('\x01','\x01','\x01') == test
@test Date(true,true,true) == test
@test Date(false,true,false) == test - Dates.Year(1) - Dates.Day(1)
@test Date(false,true,true) == test - Dates.Year(1)
@test Date(true,true,false) == test - Dates.Day(1)
@test Date(uint64(1),uint64(1),uint64(1)) == test
@test Date(0xffffffffffffffff,uint64(1),uint64(1)) == test - Dates.Year(2)
@test Date(int128(1),int128(1),int128(1)) == test
@test Date(170141183460469231731687303715884105727,int128(1),int128(1)) == test - Dates.Year(2)
@test Date(uint128(1),uint128(1),uint128(1)) == test
@test Date(big(1),big(1),big(1)) == test
@test Date(big(1),big(1),big(1)) == test
# Potentially won't work if can't losslessly convert to Int64
@test Date(BigFloat(1),BigFloat(1),BigFloat(1)) == test
@test Date(complex(1),complex(1),complex(1)) == test
@test Date(float64(1),float64(1),float64(1)) == test
@test Date(float32(1),float32(1),float32(1)) == test
@test Date(Rational(1),Rational(1),Rational(1)) == test
@test_throws InexactError Date(BigFloat(1.2),BigFloat(1),BigFloat(1))
@test_throws InexactError Date(1 + im,complex(1),complex(1))
@test_throws InexactError Date(1.2,1.0,1.0)
@test_throws InexactError Date(1.2f0,1.f0,1.f0)
@test_throws InexactError Date(3//4,Rational(1),Rational(1)) == test
# Currently no method for convert(Int64,::Float16)
@test_throws MethodError Date(float16(1),float16(1),float16(1)) == test

# Months must be in range
@test_throws ArgumentError Dates.DateTime(2013,0,1)
@test_throws ArgumentError Dates.DateTime(2013,13,1)

# Days/Hours/Minutes/Seconds/Milliseconds roll back/forward
@test Dates.DateTime(2013,1,0) == Dates.DateTime(2012,12,31)
@test Dates.DateTime(2013,1,32) == Dates.DateTime(2013,2,1)
@test Dates.DateTime(2013,1,1,24) == Dates.DateTime(2013,1,2)
@test Dates.DateTime(2013,1,1,-1) == Dates.DateTime(2012,12,31,23)
@test Dates.Date(2013,1,0) == Dates.Date(2012,12,31)
@test Dates.Date(2013,1,32) == Dates.Date(2013,2,1)

# Test DateTime traits
a = Dates.DateTime(2000)
b = Dates.Date(2000)
@test Dates.calendar(a) == Dates.ISOCalendar
@test Dates.calendar(b) == Dates.ISOCalendar
@test Dates.precision(a) == Dates.UTInstant{Millisecond}
@test Dates.precision(b) == Dates.UTInstant{Day}
@test string(typemax(Dates.DateTime)) == "146138512-12-31T23:59:59Z"
@test string(typemin(Dates.DateTime)) == "-146138511-01-01T00:00:00Z"
@test typemax(Dates.DateTime) - typemin(Dates.DateTime) == Dates.Millisecond(9223372017043199000)
@test string(typemax(Dates.Date)) == "252522163911149-12-31"
@test string(typemin(Dates.Date)) == "-252522163911150-01-01"
@test convert(Real,b) == 730120
@test convert(Float64,b) == 730120.0
@test convert(Int32,b) == 730120
@test convert(Real,a) == 63082368000000
@test convert(Float64,a) == 63082368000000.0
@test convert(Int64,a) == 63082368000000
# Date-DateTime conversion/promotion
@test Dates.DateTime(a) == a
@test Dates.Date(a) == b
@test Dates.DateTime(b) == a
@test Dates.Date(b) == b
@test a == b
@test a == a
@test b == a
@test b == b
@test !(a < b)
@test !(b < a)
c = Dates.DateTime(2000)
d = Dates.Date(2000)
@test ==(a,c)
@test ==(c,a)
@test ==(d,b)
@test ==(b,d)
@test ==(a,d)
@test ==(d,a)
@test ==(b,c)
@test ==(c,b)
b = Dates.Date(2001)
@test b > a
@test a < b
@test a != b
@test Date(DateTime(Date(2012,7,1))) == Date(2012,7,1)

y = Dates.Year(1)
m = Dates.Month(1)
w = Dates.Week(1)
d = Dates.Day(1)
h = Dates.Hour(1)
mi = Dates.Minute(1)
s = Dates.Second(1)
ms = Dates.Millisecond(1)
@test Dates.DateTime(y) == Dates.DateTime(1)
@test Dates.DateTime(y,m) == Dates.DateTime(1,1)
@test Dates.DateTime(y,m,d) == Dates.DateTime(1,1,1)
@test Dates.DateTime(y,m,d,h) == Dates.DateTime(1,1,1,1)
@test Dates.DateTime(y,m,d,h,mi) == Dates.DateTime(1,1,1,1,1)
@test Dates.DateTime(y,m,d,h,mi,s) == Dates.DateTime(1,1,1,1,1,1)
@test Dates.DateTime(y,m,d,h,mi,s,ms) == Dates.DateTime(1,1,1,1,1,1,1)
@test_throws ArgumentError Dates.DateTime(Dates.Day(10),Dates.Month(2),y)
@test_throws ArgumentError Dates.DateTime(Dates.Second(10),Dates.Month(2),y,Dates.Hour(4))
@test_throws ArgumentError Dates.DateTime(Dates.Year(1),Dates.Month(2),Dates.Day(1),Dates.Hour(4),Dates.Second(10))
@test Dates.Date(y) == Dates.Date(1)
@test Dates.Date(y,m) == Dates.Date(1,1)
@test Dates.Date(y,m,d) == Dates.Date(1,1,1)
@test_throws ArgumentError Dates.Date(m)
@test_throws ArgumentError Dates.Date(d,y)
@test_throws ArgumentError Dates.Date(d,m)
@test_throws ArgumentError Dates.Date(m,y)