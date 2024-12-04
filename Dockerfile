# Use the official .NET SDK image for build stage
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

# Copy the project files
COPY . .

# Restore dependencies
RUN dotnet restore

# Build the project in Release mode
RUN dotnet publish -c Release -o /app

# Use a smaller runtime image for final stage
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app

# Copy the built application from the build stage
COPY --from=build /app .

# Expose the port your application runs on
EXPOSE 5000

# Set the entry point for the container
ENTRYPOINT ["dotnet", "grussmann.cz.dll"]
