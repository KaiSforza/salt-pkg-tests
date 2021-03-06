{# Import global parameters that source from grains and pillars #}
{% import 'params.jinja' as params %}

{% if params.use_repo_salt_fbsd %}
add_repo_conf:
  file.managed:
    - name: /usr/local/etc/pkg/repos/saltstack.conf
    - contents: |
        saltstack: {
        url: "https://repo.saltstack.com/freebsd/${ABI}/",
        enabled: yes
        }
{% endif %}

install_salt:
  cmd.run:
    - name: 'pkg install py27-salt -y'
