require "utils"

t = 0
t0 = 0
ticsPerHour = 10

diffs = 0
ndiffs = 0
madiff = 0
midiff = 1000
shouldFireEvent = probgen(3, 2)
for t_=0,100000 do
	t = t_
	local s = shouldFireEvent(t0)
	if s then
		--print((t)/ticsPerHour)
		diff = (t - t0)/ticsPerHour
		diffs = diffs + (t - t0)/ticsPerHour
		ndiffs = ndiffs + 1
		madiff = math.max(madiff, diff)
		midiff = math.min(midiff, diff)
		t0 = t
	end
end
print(madiff.." "..diffs/ndiffs.." "..midiff)
