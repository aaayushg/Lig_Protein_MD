import glob
i='11.par'
for filepath in glob.iglob('./*.conf'):
    with open(filepath) as file:
        s = file.read()
    s = s.replace('1.par', i)
    with open(filepath, "w") as file:
        file.write(s)
