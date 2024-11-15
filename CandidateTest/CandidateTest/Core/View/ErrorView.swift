import SwiftUI

struct ErrorView: View {
    
    // MARK: Properties
    let title: String
    let message: String
    let buttonTitle: String
    let icon: String
    let action: () -> Void
    
    // MARK: Initializers
    init(
        title: String = "Oops!",
        message: String,
        buttonTitle: String = "Try Again",
        icon: String = "exclamationmark.triangle",
        action: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.icon = icon
        self.action = action
    }
    
    // Convenience initializer for NetworkError
    init(error: NetworkError, action: @escaping () -> Void) {
        self.init(
            message: error.errorDescription ?? "Something went wrong",
            action: action
        )
    }
    
    // MARK: Body
    var body: some View {
        VStack(spacing: 20) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundColor(.red.opacity(0.8))
            
            // Message
            VStack(spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            // Button
            Button(action: action) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                    Text(buttonTitle)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#if DEBUG
// MARK: - Preview
struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Network Error
            ErrorView(error: .invalidURL) {}
                .previewDisplayName("Network Error")
            
            // Custom Error
            ErrorView(
                title: "No Internet",
                message: "Please check your connection",
                buttonTitle: "Settings",
                icon: "wifi.slash"
            ) {}
                .previewDisplayName("Custom Error")
            
            // Simple Error
            ErrorView(message: "Something went wrong") {}
                .previewDisplayName("Simple Error")
        }
    }
}
#endif
