class Stack:
    def __init__(self):
        self.stack = []
    def push(self, item):
        self.stack.append(item) 
        print(f"Pushed: {item}")
    def pop(self):
        if self.is_empty():
            
            return "stack is empty"
        return self.stack.pop()
    def peek(self):
        if self.is_empty():
            return "stack is empty"
        return self.stack[-1]   
    def is_empty(self):
        return len(self.stack) == 0     
    def size(self):
        return len(self.stack)  
    def __repr__(self):
        return f"Stack({self.stack})"
s=Stack()
s.push(10)
s.push(20)
s.push(30);s.push(40);s.push(50)
# print(f"top element is:{s.peek()}")
# print(f"Popped element is:{s.pop()}")
# print(f"Popped element is:{s.pop()}")
# print(f"Stack size is:{s.size()}")
# s.pop()
# s.pop()
# print(s)
for x in reversed(s.stack): print(x)