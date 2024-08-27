> **Note**: The document is currently drafted temporarily and is not yet complete.

# Infrastructures

## Overview

This document describes a portfolio project designed to demonstrate the practical application of deploying an e-commerce platform on cloud infrastructure. It outlines the infrastructure setup for a fictional e-commerce company, **Idelior**, operating under the domain `idelior.com`.

## Objectives

- **Scalability**: The system must be capable of scaling to accommodate increasing traffic and data.
- **High Availability**: The infrastructure should be designed to operate continuously without service interruptions.
- **Automation**: Deployment and management tasks should be automated to enhance efficiency and reliability.
- **Security**: Security measures should be strengthened to ensure the safety of the company’s data and services.

## Technologies and Services

- **Shopizer**: [Shopizer](https://www.shopizer.com) is an open-source, Java-based e-commerce platform with a Headless architecture. The infrastructure assumes **Idelior provides Shopizer**. It includes:
    - **Frontend**: React JS for dynamic user interfaces.
    - **Backend**: Spring Boot-based server-side environment.
    - **Administration**: Angular for platform management.

- **GoDaddy**: [GoDaddy](https://www.godaddy.com) offers domain registration and web hosting services. This project assumes **Idelior manages its domain through GoDaddy**.

- **Google Workspace**: Google Workspace provides cloud-based productivity tools. Gmail is used for email, and Google Workspace offers centralized account management. This project assumes **Idelior utilizes Google Workspace**.

- **Amazon Web Services**: [Amazon Web Services](https://aws.amazon.com)(AWS) provides scalable cloud computing resources. This project assumes **Idelior leverages AWS** for its infrastructure needs.

Kubernetes (k8s)

Kubernetes automates the deployment and management of containerized applications. It is used for scaling and managing microservices in this project.
GitHub Actions

GitHub Actions automates CI/CD workflows for consistent code integration and deployment.
ArgoCD

ArgoCD is a GitOps tool for Kubernetes that manages application deployments from Git repositories.
Terraform

Teraform is used for Infrastructure as Code (IaC), allowing the management and provisioning of cloud resources through code.



### Amazon Web Services

 is a platform used by numerous large enterprises in real-world operational environments. The project aims to provide direct experience with various operational scenarios, facilitating the acquisition of practical skills and enhancement of problem-solving abilities. Therefore, the infrastructure is designed with the assumption that **Idelior leverages AWS**.

### GoDaddy

 is a widely recognized domain registration and web hosting platform known for its reliable domain registration processes. By leveraging available promotions, `idelior.com` was acquired at a competitive price. Consequently, it is assumed that **Idelior manages its domain through GoDaddy**.

### Google Workspace

[Google Workspace](https://workspace.google.com) is a comprehensive suite of cloud-based productivity and collaboration tools that includes applications such as Gmail, Google Drive, Google Docs, Google Sheets, and Google Meet. Gmail is widely used by large enterprises as an email service, and Google Workspace offers centralized account management features. Therefore, it is assumed in this project that **Idelior utilizes Google Workspace** to enhance internal communication and streamline operations.








## Steps and Rationale

1. Purchase the Domain from GoDaddy

Rationale:

    Established Reputation: GoDaddy is a well-known and reliable domain registrar with a strong track record, ensuring a secure and stable domain registration process.
    Comprehensive Management Tools: GoDaddy provides an intuitive interface for managing DNS settings, domain transfers, and renewal processes, simplifying domain management.
    Additional Services: GoDaddy offers additional services such as website hosting and SSL certificates, which can be useful for expanding the company's online presence in the future.

2. Register for Google Workspace

Rationale:

    Professional Communication: Google Workspace allows Idelior to use a custom domain email (e.g., contact@idelior.com), enhancing professionalism and brand identity in all communications.
    Integrated Tools: Google Workspace provides a suite of integrated productivity tools (Gmail, Google Drive, Google Docs, etc.) that streamline collaboration and document management for the team.
    Scalability and Reliability: Google Workspace offers scalable solutions that can grow with the company, along with high reliability and uptime, ensuring that email and collaboration tools are always available.

3. Set Up AWS for Service Infrastructure

Rationale:

    Scalable Infrastructure: AWS provides a wide range of scalable cloud services, including compute, storage, and databases, which can easily accommodate the growing needs of Idelior's e-commerce platform.
    Cost Efficiency: AWS's pay-as-you-go pricing model ensures that the company only pays for the resources it uses, optimizing costs and allowing for budget flexibility.
    Global Reach and Reliability: With AWS's global network of data centers, Idelior can deliver fast and reliable service to customers worldwide, improving the overall user experience and ensuring high availability.

Conclusion

By leveraging GoDaddy for domain registration, Google Workspace for professional communication and collaboration, and AWS for scalable and reliable infrastructure, Idelior establishes a strong foundation for its e-commerce platform. The use of Bash scripts and Terraform for automation further enhances efficiency and consistency in managing the infrastructure.
