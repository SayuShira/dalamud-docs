FROM node:lts-alpine AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable
WORKDIR /app

RUN npm install -g npm@latest
RUN wget -qO- https://get.pnpm.io/install.sh | ENV="$HOME/.shrc" SHELL="$(which sh)" sh -

FROM base AS deps
COPY . /app
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile

FROM base
COPY --from=deps /app/node_modules /app/node_modules

EXPOSE 3000
ENTRYPOINT [ "pnpm", "start", "--host", "0.0.0.0"]