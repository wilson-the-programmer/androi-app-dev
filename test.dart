import tkinter as tk

def add_to_expression(value):
    current = entry_var.get()
    if value == ".":
        if current and current[-1].isdigit():
            parts = current.split("+")
            parts = parts[-1].split("-")
            parts = parts[-1].split("*")
            parts = parts[-1].split("/")
            if "." in parts[-1]:
                return
    entry_var.set(entry_var.get() + value)

def clear():
    entry_var.set("")

def calculate():
    expr = entry_var.get()
    if not expr:
        return
    while expr and expr[-1] in "+-*/":
        expr = expr[:-1]
    try:
        result = eval(expr)
        entry_var.set(str(result))
    except:
        entry_var.set("Error")

root = tk.Tk()
root.title("Dark Calculator")
root.configure(bg="black")

entry_var = tk.StringVar()
entry_frame = tk.Frame(root, bg="white", bd=2, relief="ridge")
entry_frame.grid(row=0, column=0, columnspan=4, sticky="nsew", padx=5, pady=5)
entry = tk.Entry(entry_frame, textvariable=entry_var, font=("Arial", 20), bg="black", fg="white", bd=0, justify="right")
entry.pack(fill="both", expand=True)

buttons = [
    ('7', 1, 0), ('8', 1, 1), ('9', 1, 2), ('/', 1, 3),
    ('4', 2, 0), ('5', 2, 1), ('6', 2, 2), ('*', 2, 3),
    ('1', 3, 0), ('2', 3, 1), ('3', 3, 2), ('-', 3, 3),
    ('0', 4, 0), ('.', 4, 1), ('=', 4, 2), ('+', 4, 3),
    ('C', 5, 0)
]

for (text, row, col) in buttons:
    if text == "=":
        btn = tk.Button(root, text=text, command=calculate, font=("Arial", 18), bg="beige", fg="blue", bd=2, relief="ridge")
    elif text == "C":
        btn = tk.Button(root, text=text, command=clear, font=("Arial", 18), bg="red", fg="white", bd=2, relief="ridge")
    else:
        btn = tk.Button(root, text=text, command=lambda t=text: add_to_expression(t), font=("Arial", 18), bg="beige", fg="blue", bd=2, relief="ridge")
    btn.grid(row=row, column=col, sticky="nsew", padx=3, pady=3)

for i in range(6):
    root.grid_rowconfigure(i, weight=1)
for i in range(4):
    root.grid_columnconfigure(i, weight=1)

root.mainloop()