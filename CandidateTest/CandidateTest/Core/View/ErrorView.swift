import SwiftUI

struct ErrorView: View {
    
    // MARK: - Properties
    let title: String
    let message: String
    let buttonTitle: String
    let icon: String
    let action: () -> Void
    
    // MARK: - Initializers
    init(
        title: String = Strings.Common.error,
        message: String,
        buttonTitle: String = Strings.Common.retry,
        icon: String = SystemImages.error,
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
            message: error.errorDescription ?? Strings.Common.somethingWentWrong,
            action: action
        )
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: Layout.Spacing.medium) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: Layout.Size.iconSize))
                .foregroundColor(Style.Colors.error.opacity(Style.Opacity.heavy))
            
            // Message
            VStack(spacing: Layout.Spacing.xSmall) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(Style.Colors.Text.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Layout.Spacing.medium)
            }
            
            // Button
            Button(action: action) {
                HStack(spacing: Layout.Spacing.xSmall) {
                    Image(systemName: SystemImages.retry)
                    Text(buttonTitle)
                }
                .padding(.horizontal, Layout.Spacing.medium)
                .padding(.vertical, Layout.Spacing.modalActionButtonPadding)
                .background(Style.Colors.Button.primary)
                .foregroundColor(Style.Colors.Text.white)
                .cornerRadius(Layout.Radius.xxSmall)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#if DEBUG
// MARK: - Preview
struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            // Network Error
            ErrorView(error: .invalidURL) {}
                .previewDisplayName("Network Error")
            
            // Custom Error
            ErrorView(
                title: "No Internet",
                message: "Please check your connection",
                icon: SystemImages.noInternet
            ) {}
                .previewDisplayName("Custom Error")
            
            // Simple Error
            ErrorView(message: Strings.Common.somethingWentWrong) {}
                .previewDisplayName("Simple Error")
        }
    }
}
#endif
