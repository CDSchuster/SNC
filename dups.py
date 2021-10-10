lista=list(open("search01.txt", "r"))

a=[k.split("\n")[0] for k in lista]
a=a[:-1]
print(a)
print(len(a))
print(len(set(a)))