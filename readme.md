## Coding Challenge: Swift / SwiftUI

### Challenge Description

Welcome to the **SwiftUI Challenge**!

In this challenge, you'll create a Chat App—a sleek and interactive messaging application that enables users to engage in conversations with an AI assistant. The app features an intuitive interface that allows users to effortlessly communicate with the AI by typing their messages. The AI responds to user queries after a brief delay, providing a realistic conversational experience.

The Chat App connects to a server through a REST API. While the specific API is not provided, your task is to **mock the API responses** to simulate interaction. You'll implement the required logic to simulate the communication between the app and the server, giving a glimpse of how the app would function in a real-world scenario.

The goal of this challenge is to showcase your ability to create a seamless user experience by combining visually appealing SwiftUI views with the core functionality of a chat application. Through your implementation, demonstrate your skills in creating maintainable codebases, handling user input, and crafting engaging animations.

### Requirements

1. **Message Handling:**
   - Implement functionality for sending and receiving messages in the `ChatView` and `ChatViewModel`.
   - Separate UI and business logic code appropriately.

2. **Simulated Response Delay:**
   - When a user sends a message, simulate a delay before displaying the AI’s response.
   - Display a simple animation during this delay to indicate that the app is processing the request.

3. **API Service:**
   - Create a service that connects to the mocked API.

4. **Dark Mode Compatibility:**
   - Ensure the app’s design is optimized for dark mode, maintaining a professional look and feel.

5. **Plus Menu Animation:**
   - Implement the Plus Menu as shown in the provided Figma file.
   - Recreate the Plus Menu animation similar to the one in iMessage. (Open an iMessage conversation on your iPhone and press the Plus Button next to the input field to see the animation.)

### Guidelines

- **User Interface:**
  - Ensure the UI is smooth, responsive, and visually appealing.
  - Pay attention to the design specifications provided.
  - If anything is unclear or not included in the designs, make reasonable assumptions and proceed in a way that enhances the app’s look and feel.

- **Libraries & Dependencies:**
  - You may use external libraries or dependencies, but do so with caution.

- **Code Quality:**
  - Focus on writing clean, maintainable, and modular code.
  - Utilize native components where applicable.
  - Add comments to the code where necessary.
  - Follow a Clean MVVM architecture.

### Deliverables

- A SwiftUI Xcode project containing your implementation.
- A brief explanation of how you would implement the API calls.
