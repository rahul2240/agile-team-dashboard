module ApplicationHelper
  def new_link_to(resource, text = 'new')
    url = url_for(action: :new, controller: resource)
    link_to text, url, class: 'ui right floated inverted green button'
  end

  def gravatar(url, alt = 'gravatar')
    image_tag url, class: 'ui avatar image mini', alt: alt
  end

  def github_link_to(login)
    link_to "https://github.com/#{login}", target: :_blank do
      safe_join([content_tag(:i, '', class: 'github icon'), login])
    end
  end

  def avatar(user, size: 200, gravatar: false)
    klass = gravatar ? 'ui avatar image mini' : 'ui fluid circular image'

    url = if user.github_login
            "https://github.com/#{user.github_login}.png?size=#{size}"
          else
            Identicon.data_url_for(user.email)
          end

    image_tag url, class: klass
  end
end
