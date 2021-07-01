// pub contract HelloWorld {

//     // Declare a public field of type String.
//     //
//     // All fields must be initialized in the init() function.
//     pub let greeting: String

//     // The init() function is required if the contract contains any fields.
//     init() {
//         self.greeting = "Hello, World!"
//     }

//     // Public function that returns our friendly greeting!
//     pub fun hello(): String {
//         return self.greeting
//     }
// }

import HelloWorld from 0x27292e2145d5bb72

transaction {

    // No need to do anything in prepare because we are not working with
    // account storage.
    prepare(acct: AuthAccount) {}

    // In execute, we simply call the hello function
    // of the HelloWorld contract and log the returned String.
    execute {
        log(HelloWorld.hello())
    }
}