# Use the official .NET SDK image for the build stage
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

# Update and upgrade packages (optional step for latest updates)
RUN apt-get update && apt-get upgrade -y && apt-get clean

# Copy the project files
COPY . .

# Restore dependencies
RUN dotnet restore

# Build the project in Release mode
RUN dotnet publish -c Release -o /app

# Use a smaller runtime image for the final stage
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app

# Update and upgrade packages in the runtime image (optional)
RUN apt-get update && apt-get upgrade -y && apt-get clean

# Copy the built application from the build stage
COPY --from=build /app .

# Expose the port your application runs on
EXPOSE 5000

# Set the entry point for the container
ENTRYPOINT ["dotnet", "grussmann.cz.dll"]
