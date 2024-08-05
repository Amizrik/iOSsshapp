import SwiftUI

struct ContentView: View {
    @StateObject private var sshManager = SSHManager()
    @State private var host = ""
    @State private var username = ""
    @State private var password = ""
    @State private var command = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Connection")) {
                    TextField("Host", text: $host)
                    TextField("Username", text: $username)
                    SecureField("Password", text: $password)
                    Button(action: connectOrDisconnect) {
                        Text(sshManager.isConnected ? "Disconnect" : "Connect")
                    }
                    .disabled(host.isEmpty || username.isEmpty || password.isEmpty)
                }
                
                Section(header: Text("Command")) {
                    TextField("Enter command", text: $command)
                    Button("Execute") {
                        sshManager.executeCommand(command)
                        command = ""
                    }
                    .disabled(!sshManager.isConnected || command.isEmpty)
                }
                
                Section(header: Text("Output")) {
                    TextEditor(text: .constant(sshManager.output))
                        .frame(height: 200)
                }
            }
            .navigationTitle("iOSsshtest")
        }
    }
    
    func connectOrDisconnect() {
        if sshManager.isConnected {
            sshManager.disconnect()
        } else {
            sshManager.connect(host: host, username: username, password: password)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

