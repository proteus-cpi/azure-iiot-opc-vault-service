FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY src/Microsoft.Azure.IIoT.WebApps.OpcUa.Vault/src/Microsoft.Azure.IIoT.WebApps.OpcUa.Vault.csproj src/Microsoft.Azure.IIoT.WebApps.OpcUa.Vault/src/
COPY NuGet.Config NuGet.Config
COPY *.props /
RUN dotnet restore --configfile NuGet.Config -nowarn:msb3202,nu1503 src/Microsoft.Azure.IIoT.WebApps.OpcUa.Vault/src/Microsoft.Azure.IIoT.WebApps.OpcUa.Vault.csproj
COPY . .
WORKDIR /src/src/Microsoft.Azure.IIoT.WebApps.OpcUa.Vault/src
RUN dotnet build Microsoft.Azure.IIoT.WebApps.OpcUa.Vault.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish Microsoft.Azure.IIoT.WebApps.OpcUa.Vault.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "Microsoft.Azure.IIoT.WebApps.OpcUa.Vault.dll"]
