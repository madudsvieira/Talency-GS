FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /source

COPY Talency.sln ./

COPY src/Api/Api.csproj src/Api/
COPY src/Application/Application.csproj src/Application/
COPY src/Domain/Domain.csproj src/Domain/
COPY src/Infrastructure/Infrastructure.csproj src/Infrastructure/
COPY tests/tests.csproj tests/

RUN dotnet restore "src/Api/Api.csproj"

COPY . .

RUN dotnet publish "src/Api/Api.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app

COPY --from=build /app/publish .

EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

ENTRYPOINT ["dotnet", "Api.dll"]
