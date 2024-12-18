# Use the official .NET Core 3.1 SDK image for the build stage
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src

# Update and upgrade packages (optional step for latest updates)
RUN apt-get update && apt-get upgrade -y && apt-get clean

# Copy the project files
COPY . . 

# Install DevExpress.Xpo and Npgsql dependencies (add them to the project)
RUN dotnet add package DevExpress.Xpo
RUN dotnet add package Npgsql --version 4.1.9

# Restore dependencies
RUN dotnet restore

# Build the project in Release mode
RUN dotnet publish -c Release -o /app

# Use the official .NET Core 3.1 runtime image for the runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS runtime
WORKDIR /app

# Update and upgrade packages in the runtime image (optional)
RUN apt-get update && apt-get upgrade -y && apt-get clean

# Set environment variable to make the app listen on all interfaces (0.0.0.0)
ENV ASPNETCORE_URLS=http://0.0.0.0:5000

# Copy the built application from the build stage
COPY --from=build /app . 

# Expose the port your application runs on
EXPOSE 5000

# Set the entry point for the container
ENTRYPOINT ["dotnet", "grussmann.cz.dll"]


# use 
#docker build -t app . 
#docker run -d -p 8080:5000 app
# to run the container
